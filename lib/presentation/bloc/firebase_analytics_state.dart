part of 'firebase_analytics_cubit.dart';

abstract class FirebaseAnalyticsState extends Equatable {
  const FirebaseAnalyticsState();

  @override
  List<Object> get props => [];
}

class FirebaseAnalyticsInitial extends FirebaseAnalyticsState {}

class FirebaseAnalyticsLoading extends FirebaseAnalyticsState {}

class FirebaseAnalyticsEventLoaded extends FirebaseAnalyticsState {}

class FirebaseAnalyticsError extends FirebaseAnalyticsState {
  const FirebaseAnalyticsError({
    required this.message,
  });
  final String message;

  @override
  List<Object> get props => [message];
}
