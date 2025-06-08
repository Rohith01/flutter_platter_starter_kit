import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/presentation/bloc/firebase_notifications_state.dart';

class FCMCubit extends Cubit<FCMState> {
  FCMCubit(this.fcm) : super(FCMInitial());
  final FirebaseMessaging fcm;
  // Future<void> backgroundHandler(RemoteMessage message) async {
  //   debugPrint('Handling a background message ${message.messageId}');
  // }
  //TODO:: backgroundHandler to be implemented

  void initialiseFCM() async {
    try {
      Future<String?> getToken() async {
        final String? token = await fcm.getToken();
        debugPrint('Token: $token');
        return token;
      }

      // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });

      // Get the token
      await getToken();
    } catch (e) {
      debugPrint('fcm error');

      debugPrint(e.toString());
    }
  }
}
