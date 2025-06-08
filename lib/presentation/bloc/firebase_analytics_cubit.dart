import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/services/repository/firebase_analytics_repository.dart';

part 'firebase_analytics_state.dart';

class FirebaseAnalyticsCubit extends Cubit<FirebaseAnalyticsState> {
  FirebaseAnalyticsCubit(this.firebaseAnalyticsRepository)
    : super(FirebaseAnalyticsInitial());
  final FirebaseAnalyticsRepository firebaseAnalyticsRepository;

  void addEvent({
    required String eventName,
    Map<String, String>? eventParams,
  }) async {
    emit(FirebaseAnalyticsLoading());
    try {
      await firebaseAnalyticsRepository.addEvent(
        eventName: eventName,
        eventParams: eventParams,
      );
      emit(FirebaseAnalyticsEventLoaded());
    } catch (e) {
      emit(FirebaseAnalyticsError(message: e.toString()));
    }
  }

  void setUserParams() async {
    emit(FirebaseAnalyticsLoading());
    try {
      await firebaseAnalyticsRepository.setUserParams();
      emit(FirebaseAnalyticsEventLoaded());
    } catch (e) {
      emit(FirebaseAnalyticsError(message: e.toString()));
    }
  }
}
