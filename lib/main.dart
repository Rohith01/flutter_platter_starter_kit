import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/constants.dart';
import 'package:flutter_platter/core/di.dart' as di;
import 'package:flutter_platter/firebase_options.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/fetch_joke_cubit.dart';
import 'package:flutter_platter/presentation/bloc/firebase_analytics_cubit.dart';
import 'package:flutter_platter/presentation/bloc/firebase_notifications_cubit.dart';
import 'package:flutter_platter/presentation/bloc/manage_user_profile_cubit.dart';
import 'package:flutter_platter/presentation/bloc/theme_cubit.dart';
import 'package:flutter_platter/presentation/view/features_screen/features_screen.dart';
import 'package:flutter_platter/presentation/view/home/home_screen.dart';
import 'package:flutter_platter/presentation/view/joke_screen/joke_screen.dart';
import 'package:flutter_platter/presentation/view/login/email_login_view.dart';
import 'package:flutter_platter/presentation/view/login/email_singup_view.dart';
import 'package:flutter_platter/presentation/view/login/login_view.dart';
import 'package:flutter_platter/presentation/view/official_website/official_website_webview.dart';
import 'package:flutter_platter/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Activate app check after initialization, but before
  // usage of any Firebase services.
  await FirebaseAppCheck.instance
  // Your personal reCaptcha public key goes here:
  .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize Dependency Injection
  await di.setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GoRouter configuration
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'login',
              builder: (BuildContext context, GoRouterState state) {
                return const LoginView();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'email-login',
                  builder: (BuildContext context, GoRouterState state) {
                    return const EmailLoginView();
                  },
                ),
                GoRoute(
                  path: 'email-signup',
                  builder: (BuildContext context, GoRouterState state) {
                    return const EmailSignUpView();
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'joke',
              builder: (BuildContext context, GoRouterState state) {
                return const JokeScreen();
              },
            ),
            GoRoute(
              path: 'website',
              builder: (BuildContext context, GoRouterState state) {
                return const OfficialWebsiteWebview();
              },
            ),
            GoRoute(
              path: 'features',
              builder: (BuildContext context, GoRouterState state) {
                return FeaturesScreen();
              },
            ),
          ],
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => di.sl<ManageUserProfileCubit>()),
            BlocProvider(create: (context) => di.sl<AuthBloc>()),
            BlocProvider(create: (context) => di.sl<FirebaseAnalyticsCubit>()),
            BlocProvider(create: (context) => di.sl<FCMCubit>()),
            BlocProvider(create: (context) => di.sl<ThemeCubit>()),
            BlocProvider(create: (context) => di.sl<FetchJokeCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                title: 'Flutter Platter',
                theme:
                    state == const IsDarkTheme(isDarkTheme: false)
                        ? lightTheme
                        : darkTheme,
                routerConfig: router,
              );
            },
          ),
        );
      },
    );
  }
}
