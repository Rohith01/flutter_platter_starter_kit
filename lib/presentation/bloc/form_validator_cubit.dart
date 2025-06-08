import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_validator_state.dart';

class FormValidatorCubit extends Cubit<FormValidatorState> {
  FormValidatorCubit() : super(const FormValidatorUpdate());

  void initForm({
    String email = '',
    String name = '',
  }) {
    emit(state.copyWith(
      email: email,
      name: name,
    ));
  }

  void updateEmail(String? email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String? password) {
    emit(state.copyWith(password: password));
  }

  void updateConfirmPassword(String? confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void updateName(String? name) {
    emit(state.copyWith(name: name));
  }

  void updateAutovalidateMode(AutovalidateMode? autovalidateMode) {
    emit(state.copyWith(autovalidateMode: autovalidateMode));
  }

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }

  void reset() {
    emit(const FormValidatorUpdate());
  }
}
