part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class PhoneAuthInitial extends AuthState {}

// This state is used to show the loading indicator when the phone number is being sent to the server for verification and the user is being redirected to the verification page.
class AuthLoading extends AuthState {}

// This state is used to show the error message.
class PhoneAuthError extends AuthState {
  const PhoneAuthError({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}

// This state indicates that verification is completed and the user is being redirected to the home page.
class PhoneAuthVerifiedOldUser extends AuthState {}

class PhoneAuthVerifiedNewUser extends AuthState {}

class AuthVerifiedOldUser extends AuthState {}

class AuthVerifiedNewUser extends AuthState {}

class AuthSignUpWithEmailAndPasswordSuccess extends AuthState {}

// This state is used to show the OTP widget in which the user enters the OTP sent to his/her phone number.
class PhoneAuthCodeSentSuccess extends AuthState {
  const PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });
  final String verificationId;
  @override
  List<Object> get props => [verificationId];
}

class UserLoggedOutState extends AuthState {}

class PasswordResetSentState extends AuthState {}

class AuthSuccessButEmailNotVerifiedState extends AuthState {}

class EmailVerificationSentState extends AuthState {}
