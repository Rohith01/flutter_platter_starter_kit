import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/constants.dart';
import 'package:flutter_platter/core/snackbar_util.dart';
import 'package:flutter_platter/core/validator.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/firebase_analytics_cubit.dart';
import 'package:flutter_platter/presentation/bloc/form_validator_cubit.dart';
import 'package:flutter_platter/presentation/view/widgets/logo_heading_widget.dart';
import 'package:flutter_platter/presentation/view/widgets/rounded_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailLoginView extends StatefulWidget with Validator {
  const EmailLoginView({super.key});

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passswordController;
  final FormValidatorCubit _formValidatorCubit = FormValidatorCubit();

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          children: [
            const LogoHeader(),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is PhoneAuthVerifiedNewUser ||
                    state is AuthVerifiedNewUser) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(
                    context,
                  ).addEvent(eventName: 'recieved_email_login_success');
                  context.go('/');
                }
                if (state is PhoneAuthVerifiedOldUser ||
                    state is AuthVerifiedOldUser) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(
                    context,
                  ).addEvent(eventName: 'recieved_email_login_success');
                  context.go('/');
                }

                if (state is PasswordResetSentState) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(context).addEvent(
                    eventName: 'recieved_password_reset_email_message',
                  );
                  showSnackBar(
                    context: context,
                    message: 'Password reset link sent to email!! Please check',
                    showAction: false,
                  );
                }
                if (state is AuthSuccessButEmailNotVerifiedState) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(
                    context,
                  ).addEvent(eventName: 'recieved_email_not_verified_error');
                  showSnackBar(
                    context: context,
                    message: 'Email is not verified. Please check your email',
                    showAction: true,
                    actionLabel: 'resend verification',
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(
                        context,
                      ).add(const ResendVerificationEmail());
                    },
                  );
                }
                if (state is EmailVerificationSentState) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(
                    context,
                  ).addEvent(eventName: 'recieved_email_resent_message');
                  showSnackBar(
                    context: context,
                    message: 'Verification email sent! Please verify and Login',
                    showAction: false,
                  );
                }

                //Show error message if any error occurs while verifying phone number and otp code
                if (state is PhoneAuthError) {
                  BlocProvider.of<FirebaseAnalyticsCubit>(context).addEvent(
                    eventName: 'recieved_email_login_error',
                    eventParams: {'error_message': state.error},
                  );
                  showSnackBar(
                    context: context,
                    message: state.error,
                    showAction: false,
                  );
                }
              },
              builder: (context, state) {
                return BlocSelector<
                  FormValidatorCubit,
                  FormValidatorState,
                  AutovalidateMode
                >(
                  bloc: _formValidatorCubit,
                  selector: (state) => state.autovalidateMode,
                  builder: (context, AutovalidateMode autovalidateMode) {
                    return Form(
                      key: _loginFormKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: widget.validateEmail,
                            onChanged: _formValidatorCubit.updateEmail,
                            controller: _emailController,
                            style: Theme.of(context).textTheme.bodyLarge,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            validator: widget.validatePassword,
                            onChanged: _formValidatorCubit.updatePassword,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passswordController,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ), //formInputDecoration(label: 'Password'),
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              if (widget.validateEmail(_emailController.text) ==
                                  null) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  ResetPasswordEvent(
                                    email: _emailController.text,
                                  ),
                                );
                              } else {
                                showSnackBar(
                                  context: context,
                                  message:
                                      'Please enter email to reset password',
                                  showAction: false,
                                );
                              }
                            },
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(height: 20),
                          RoundedButton(
                            isLoading: state is AuthLoading,
                            title: 'Login',
                            width: 200.w,
                            titleTextStyle: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(color: kPrimary),
                            onTap: () {
                              if (_loginFormKey.currentState!.validate()) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  LoginWithEmailAndPasswordEvent(
                                    email: _emailController.text,
                                    password: _passswordController.text,
                                  ),
                                );
                                BlocProvider.of<FirebaseAnalyticsCubit>(
                                  context,
                                ).addEvent(
                                  eventName: 'click_email_login_button',
                                );
                              } else {
                                // in case a user has submitted invalid form we'll set
                                // AutovalidateMode.always which will rebuild the form
                                // in result we'll start getting error message
                                _formValidatorCubit.updateAutovalidateMode(
                                  AutovalidateMode.always,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('--------------- OR ---------------'),
            const SizedBox(height: 20),
            RoundedButton(
              isLoading: false,
              icon: const Icon(Icons.email, size: 30),
              title: 'Create new Account',
              buttonColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                context.go('/login/email-signup');
              },
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
