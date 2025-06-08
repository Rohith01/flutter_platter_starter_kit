import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/snackbar_util.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/firebase_notifications_cubit.dart';
import 'package:flutter_platter/presentation/view/widgets/leave_app_alert_popup.dart';
import 'package:flutter_platter/presentation/view/widgets/logo_heading_widget.dart';
import 'package:flutter_platter/presentation/view/widgets/rounded_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String verificationId;

  @override
  void initState() {
    if (kIsWeb) {
      BlocProvider.of<FCMCubit>(context).initialiseFCM();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        showLeaveAppPopup(context);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PhoneAuthCodeSentSuccess) {
              verificationId = state.verificationId;
            }
            // Phone Otp Verified. Send User to Home Screen
            if (state is PhoneAuthVerifiedNewUser ||
                state is AuthVerifiedNewUser) {
              context.go('/');
            }
            if (state is PhoneAuthVerifiedOldUser ||
                state is AuthVerifiedOldUser) {
              context.go('/');
            }

            //Show error message if any error occurs while verifying phone number and otp code
            if (state is PhoneAuthError) {
              showSnackBar(
                context: context,
                message: state.error,
                showAction: false,
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const LogoHeader(showBackButton: false),
                      RoundedButton(
                        isLoading: state is AuthLoading,
                        icon: Image.asset('assets/image/g_logo.png'),
                        title: 'Continue with Google',
                        buttonColor: Theme.of(context).colorScheme.primary,
                        loadingIndicatorColor:
                            Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          BlocProvider.of<AuthBloc>(
                            context,
                          ).add(const SignInWithGoogleEvent());
                        },
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                        enable: state is! AuthLoading,
                        isLoading: false,
                        icon: const Icon(Icons.email, size: 30),
                        title: 'Continue with Email',
                        buttonColor: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          context.go('/login/email-login');
                        },
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      SizedBox(
                        width: 300,
                        child: Image.asset('assets/image/people.png'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
