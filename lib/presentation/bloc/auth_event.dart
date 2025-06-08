part of 'auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object> get props => [];
}

// This event will be triggered when the user enters the phone number and presses the Send OTP button on the UI.
class SendOtpToPhoneEvent extends PhoneAuthEvent {
  const SendOtpToPhoneEvent({required this.phoneNumber});
  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

// This event will be triggered when the user enters the OTP and presses the Verify OTP button on the UI.
class VerifySentOtpEvent extends PhoneAuthEvent {
  const VerifySentOtpEvent(
      {required this.otpCode, required this.verificationId});
  final String otpCode;
  final String verificationId;

  @override
  List<Object> get props => [otpCode, verificationId];
}

// This event will be triggered when firebase sends the OTP to the user's phone number.
class OnPhoneOtpSent extends PhoneAuthEvent {
  const OnPhoneOtpSent({
    required this.verificationId,
    required this.token,
  });
  final String verificationId;
  final int? token;

  @override
  List<Object> get props => [verificationId];
}

// This event will be triggered when any error occurs while sending the OTP to the user's phone number. This can be due to network issues or firebase's error.
class OnPhoneAuthErrorEvent extends PhoneAuthEvent {
  const OnPhoneAuthErrorEvent({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}

// This event will be triggered when the verification of the OTP is successful.
class OnPhoneAuthVerificationCompleteEvent extends PhoneAuthEvent {
  const OnPhoneAuthVerificationCompleteEvent({
    required this.credential,
  });
  final AuthCredential credential;
}

// This event will be triggered when the user enters the phone number and presses the Send OTP button on the UI.
class SignInWithGoogleEvent extends PhoneAuthEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

// This event will be triggered when the user presses login with email on the UI.
class LoginWithEmailAndPasswordEvent extends PhoneAuthEvent {
  const LoginWithEmailAndPasswordEvent(
      {required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

// This event will be triggered when the user presses signup button on the UI.
class SignUpWithEmailAndPasswordEvent extends PhoneAuthEvent {
  const SignUpWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
    required this.displayName,
  });
  final String email;
  final String password;
  final String displayName;

  @override
  List<Object> get props => [email, password, displayName];
}

class IsUserLoggedIn extends PhoneAuthEvent {
  const IsUserLoggedIn();

  @override
  List<Object> get props => [];
}

// This event will be triggered when user tries to logout
class OnLogOutEvent extends PhoneAuthEvent {
  const OnLogOutEvent();
}

class ResetPasswordEvent extends PhoneAuthEvent {
  const ResetPasswordEvent({required this.email});
  final String email;
  @override
  List<Object> get props => [email];
}

class ResendVerificationEmail extends PhoneAuthEvent {
  const ResendVerificationEmail();
}
