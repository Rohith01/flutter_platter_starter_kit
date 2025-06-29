import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/constants.dart';
import 'package:flutter_platter/core/firebase_error_code_to_message_util.dart';
import 'package:flutter_platter/services/repository/auth_repository.dart';
import 'package:flutter_platter/services/repository/firebase_db_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<PhoneAuthEvent, AuthState> {
  AuthBloc(
    this.phoneAuthRepository,
    this.firebaseDBRepository,
    this.prefs,
    this.firebaseAuth,
  ) : super(PhoneAuthInitial()) {
    // When user clicks on send otp button then this event will be fired
    on<SendOtpToPhoneEvent>(_onSendOtp);

    // After receiving the otp, When user clicks on verify otp button then this event will be fired
    on<VerifySentOtpEvent>(_onVerifyOtp);

    // When the firebase sends the code to the user's phone, this event will be fired
    on<OnPhoneOtpSent>(
      (event, emit) =>
          emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId)),
    );

    // When any error occurs while sending otp to the user's phone, this event will be fired
    on<OnPhoneAuthErrorEvent>(
      (event, emit) => emit(PhoneAuthError(error: event.error)),
    );

    // When the otp verification is successful, this event will be fired
    on<OnPhoneAuthVerificationCompleteEvent>(_loginWithCredential);
    on<LoginWithEmailAndPasswordEvent>(_loginWithEmailAndPassword);
    on<SignUpWithEmailAndPasswordEvent>(_signUpWithEmailAndPassword);

    on<OnLogOutEvent>(_onLogOut);
    on<SignInWithGoogleEvent>(_signInWithGoogle);
    on<IsUserLoggedIn>(_isUserLoggedIn);
    on<ResetPasswordEvent>(_resetPassword);
    on<ResendVerificationEmail>(_onResendVerificationEmail);
  }
  final AuthRepository phoneAuthRepository;
  final FirebaseDBRepository firebaseDBRepository;
  final SharedPreferences prefs;
  final FirebaseAuth firebaseAuth;

  FutureOr<void> _onSendOtp(
    SendOtpToPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await phoneAuthRepository.verifyPhone(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // On [verificationComplete], we will get the credential from the firebase  and will send it to the [OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [PhoneAuthVerified] state after successful login
          add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
        },
        codeSent: (String verificationId, int? resendToken) {
          // On [codeSent], we will get the verificationId and the resendToken from the firebase and will send it to the [OnPhoneOtpSent] event to be handled by the bloc and then will emit the [OnPhoneAuthVerificationCompleteEvent] event after receiving the code from the user's phone
          add(
            OnPhoneOtpSent(verificationId: verificationId, token: resendToken),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          // On [verificationFailed], we will get the exception from the firebase and will send it to the [OnPhoneAuthErrorEvent] event to be handled by the bloc and then will emit the [PhoneAuthError] state in order to display the error to the user's screen
          add(OnPhoneAuthErrorEvent(error: e.code));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _onVerifyOtp(
    VerifySentOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // After receiving the otp, we will verify the otp and then will create a credential from the otp and verificationId and then will send it to the [OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [PhoneAuthVerified] state after successful login
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _loginWithCredential(
    OnPhoneAuthVerificationCompleteEvent event,
    Emitter<AuthState> emit,
  ) async {
    // After receiving the credential from the event, we will login with the credential and then will emit the [PhoneAuthVerified] state after successful login
    try {
      await firebaseAuth.signInWithCredential(event.credential).then((user) {
        if (user.user != null) {
          final Map<String, String?> userDetails = {
            'phone': user.user!.phoneNumber,
            'email': user.user!.email,
            'name': user.user!.displayName,
          };
          firebaseDBRepository.addUserProfile(userDetails);

          if (user.user!.metadata.creationTime != null &&
              DateTime.now().isAfter(
                user.user!.metadata.creationTime!.add(
                  const Duration(minutes: 30),
                ),
              )) {
            emit(PhoneAuthVerifiedOldUser());
          } else {
            emit(PhoneAuthVerifiedNewUser());
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _loginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      User? user;

      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      user = userCredential.user;
      if (user != null && user.emailVerified) {
        await prefs.setBool('isUserLoggedIn', true);
        if (user.metadata.creationTime != null &&
            DateTime.now().isAfter(
              user.metadata.creationTime!.add(const Duration(minutes: 30)),
            )) {
          emit(AuthVerifiedOldUser());
        } else {
          emit(AuthVerifiedNewUser());
        }
      } else {
        emit(AuthSuccessButEmailNotVerifiedState());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      debugPrint('login error -- $e');
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _signUpWithEmailAndPassword(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      User? user;

      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      user = userCredential.user;
      if (user != null) {
        user.sendEmailVerification();
        final Map<String, String?> userDetails = {
          'phone': user.phoneNumber,
          'email': user.email,
          'name': event.displayName,
        };
        user.updateDisplayName(event.displayName);
        firebaseDBRepository.addUserProfile(userDetails);
        emit(AuthSignUpWithEmailAndPasswordSuccess());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      debugPrint('signUp error -- $e');
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _signInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // After receiving the otp, we will verify the otp and then will create a credential from the otp and verificationId and then will send it to the [OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [PhoneAuthVerified] state after successful login
      User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kGoogleSigninClientId,
      );

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await firebaseAuth
            .signInWithCredential(credential);

        user = userCredential.user;
        if (user != null) {
          final Map<String, String?> userDetails = {
            'phone': user.phoneNumber,
            'email': user.email,
            'name': user.displayName,
          };
          firebaseDBRepository.addUserProfile(userDetails);
          await prefs.setBool('isUserLoggedIn', true);
          if (user.metadata.creationTime != null &&
              DateTime.now().isAfter(
                user.metadata.creationTime!.add(const Duration(minutes: 30)),
              )) {
            emit(AuthVerifiedOldUser());
          } else {
            emit(AuthVerifiedNewUser());
          }
        } else {
          emit(const PhoneAuthError(error: 'Login aborted'));
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        emit(const PhoneAuthError(error: 'No Internet Connection'));
      } else {
        debugPrint('google auth error :  $e');
        emit(PhoneAuthError(error: e.toString()));
      }
    } catch (e) {
      debugPrint('google auth error :  $e');
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _isUserLoggedIn(
    IsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final bool? isUserLoggedIn = prefs.getBool('isUserLoggedIn');

      if (isUserLoggedIn == true) {
        emit(AuthVerifiedOldUser());
      } else {
        emit(UserLoggedOutState());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _onLogOut(OnLogOutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      // ignore: unnecessary_statements
      firebaseAuth.signOut;
      await prefs.setBool('isUserLoggedIn', false);

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kGoogleSigninClientId,
      );
      googleSignIn.disconnect();
      emit(UserLoggedOutState());
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _resetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(PasswordResetSentState());
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _onResendVerificationEmail(
    ResendVerificationEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final User? user = firebaseAuth.currentUser;
      if (user != null) {
        user.sendEmailVerification();
      } else {
        emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage('NA')));
      }
      emit(EmailVerificationSentState());
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      debugPrint(e.message);
      emit(PhoneAuthError(error: firebaseErrorCodetoErrorMessage(e.code)));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }
}
