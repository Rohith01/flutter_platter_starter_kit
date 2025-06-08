import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsRepositoryImpl implements FirebaseAnalyticsRepository {
  FirebaseAnalyticsRepositoryImpl({
    required this.analytics,
    required this.deviceInfoPlugin,
    required this.firebaseAnalyticsObserver,
    required this.firebaseAuth,
  });
  final FirebaseAnalytics analytics;
  final DeviceInfoPlugin deviceInfoPlugin;
  final FirebaseAnalyticsObserver firebaseAnalyticsObserver;
  final FirebaseAuth firebaseAuth;

  @override
  Future<void> setUserParams() async {
    final deviceData = <String, dynamic>{};
    if (kIsWeb) {
      _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    }

    final userId = firebaseAuth.currentUser!.uid;
    await analytics.setUserId(id: userId);
    if (deviceData.isNotEmpty) {
      await analytics.setUserProperty(
          name: 'app_version', value: deviceData['0.2.0']);
      await analytics.setUserProperty(
          name: 'device_name', value: deviceData['device_name']);
      await analytics.setUserProperty(
          name: 'device_brand', value: deviceData['device_brand']);
      await analytics.setUserProperty(
          name: 'device_version_baseOS',
          value: deviceData['device_version_baseOS']);
      await analytics.setUserProperty(
          name: 'device_id', value: deviceData['device_id']);
    }
  }

  @override
  Future<void> addEvent(
      {required String eventName, Map<String, Object>? eventParams}) async {
    await analytics.logEvent(
      name: eventName,
      parameters: eventParams,
    );
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'device_version_baseOS': build.version.baseOS,
    'device_brand': build.brand,
    'device_name': build.device,
    'device_id': build.id,
  };
}

abstract class FirebaseAnalyticsRepository {
  Future<void> setUserParams();
  Future<void> addEvent(
      {required String eventName, Map<String, Object>? eventParams});
}
