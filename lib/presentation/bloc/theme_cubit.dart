import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this.sharedPrefs) : super(const IsDarkTheme(isDarkTheme: false));
  final SharedPreferences sharedPrefs;

  void checkTheme() async {
    if (sharedPrefs.getBool('isDarkTheme') == null) {
      sharedPrefs.setBool('isDarkTheme', false);
      emit(const IsDarkTheme(isDarkTheme: false));
    } else {
      sharedPrefs.setBool('isDarkTheme', sharedPrefs.getBool('isDarkTheme')!);
      emit(IsDarkTheme(isDarkTheme: sharedPrefs.getBool('isDarkTheme')!));
    }
  }

  void toggleTheme() async {
    final bool isDarkThemeValue = sharedPrefs.getBool('isDarkTheme') ?? false;
    sharedPrefs.setBool('isDarkTheme', !isDarkThemeValue);
    emit(IsDarkTheme(isDarkTheme: !isDarkThemeValue));
  }
}
