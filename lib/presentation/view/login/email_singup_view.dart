import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/snackbar_util.dart';
import 'package:flutter_platter/core/validator.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/firebase_analytics_cubit.dart';
import 'package:flutter_platter/presentation/bloc/form_validator_cubit.dart';
import 'package:flutter_platter/presentation/view/widgets/logo_heading_widget.dart';
import 'package:flutter_platter/presentation/view/widgets/rounded_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailSignUpView extends StatefulWidget with Validator {
  const EmailSignUpView({super.key});

  @override
  State<EmailSignUpView> createState() => _EmailSignUpViewState();
}

class _EmailSignUpViewState extends State<EmailSignUpView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  late TextEditingController _passswordController;
  late TextEditingController _confirmpassswordController;
  final FormValidatorCubit _formValidatorCubit = FormValidatorCubit();

  final _loginFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passswordController = TextEditingController();
    _confirmpassswordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSignUpWithEmailAndPasswordSuccess) {
                  context.go('/email-login');
                  showSnackBar(
                    context: context,
                    message: 'Verification email sent! Please verify and Login',
                    showAction: false,
                  );
                  BlocProvider.of<FirebaseAnalyticsCubit>(
                    context,
                  ).addEvent(eventName: 'recieved_email_singup_email');
                }
                //Show error message if any error occurs while verifying phone number and otp code
                if (state is PhoneAuthError) {
                  showSnackBar(
                    context: context,
                    message: state.error,
                    showAction: false,
                  );
                  BlocProvider.of<FirebaseAnalyticsCubit>(context).addEvent(
                    eventName: 'recieved_email_signup_error',
                    eventParams: {'error_message': state.error},
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.w,
                        ),
                        child: Column(
                          children: [
                            const LogoHeader(),
                            TextFormField(
                              controller: _nameController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                label: Text('Name'),
                                hintText: 'Tony Stark',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              validator: widget.validateEmail,
                              onChanged: _formValidatorCubit.updateEmail,
                              controller: _emailController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                label: Text('Email'),
                                hintText: 'ironman@gmail.com',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              validator: widget.validatePassword,
                              onChanged: _formValidatorCubit.updatePassword,
                              controller: _passswordController,
                              obscureText: true,
                              style: Theme.of(context).textTheme.bodyLarge,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                label: Text('Password'),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              validator:
                                  (value) => widget.validateConfirmPassword(
                                    value,
                                    _formValidatorCubit.state.password,
                                  ),
                              onChanged:
                                  _formValidatorCubit.updateConfirmPassword,
                              controller: _confirmpassswordController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                label: Text('Confirm Password'),
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 40.h),
                            RoundedButton(
                              title: 'Create Account',
                              titleTextStyle: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onTap: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    SignUpWithEmailAndPasswordEvent(
                                      email: _emailController.text,
                                      password: _passswordController.text,
                                      displayName: _nameController.text,
                                    ),
                                  );
                                  BlocProvider.of<FirebaseAnalyticsCubit>(
                                    context,
                                  ).addEvent(
                                    eventName: 'click_email_signup_button',
                                  );
                                } else {
                                  _formValidatorCubit.updateAutovalidateMode(
                                    AutovalidateMode.always,
                                  );
                                }
                              },
                              isLoading: state is AuthLoading,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
