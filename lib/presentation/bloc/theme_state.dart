part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class IsDarkTheme extends ThemeState {
  const IsDarkTheme({
    required this.isDarkTheme,
  });
  final bool isDarkTheme;

  @override
  List<Object> get props => [isDarkTheme];
}
