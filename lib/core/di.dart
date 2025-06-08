import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/fetch_joke_cubit.dart';
import 'package:flutter_platter/presentation/bloc/firebase_analytics_cubit.dart';
import 'package:flutter_platter/presentation/bloc/firebase_notifications_cubit.dart';
import 'package:flutter_platter/presentation/bloc/manage_user_profile_cubit.dart';
import 'package:flutter_platter/presentation/bloc/theme_cubit.dart';
import 'package:flutter_platter/services/repository/auth_repository.dart';
import 'package:flutter_platter/services/repository/fetch_joke_repository.dart';
import 'package:flutter_platter/services/repository/firebase_analytics_repository.dart';
import 'package:flutter_platter/services/repository/firebase_db_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// sl - Service locator
final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Register Blocs and Cubits here
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => FetchJokeCubit(sl()));
  sl.registerFactory(() => FCMCubit(sl()));
  sl.registerFactory(() => FirebaseAnalyticsCubit(sl()));
  sl.registerFactory(() => ManageUserProfileCubit(sl()));
  sl.registerFactory(() => ThemeCubit(sl()));

  // Register repositories here

  sl.registerLazySingleton<FetchJokeRepository>(
    () => FetchJokeRepositoryImpl(sl()),
  );

  // Register services here
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<FirebaseAnalyticsRepository>(
    () => FirebaseAnalyticsRepositoryImpl(
      analytics: sl(),
      deviceInfoPlugin: sl(),
      firebaseAnalyticsObserver: sl(),
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseDBRepository>(
    () => FirebaseDBRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  sl.registerLazySingleton<FirebaseAnalyticsObserver>(
    () => FirebaseAnalyticsObserver(analytics: sl()),
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
