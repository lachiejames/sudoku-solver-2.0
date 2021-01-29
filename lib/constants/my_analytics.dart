part of './constants.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

Future<void> logEvent(String message) async {
  await firebaseAnalytics.logEvent(name: message);
}

Future<void> logError(String message, dynamic stackTrace) async {
  await firebaseAnalytics.logEvent(
    name: message,
    parameters: <String, dynamic>{'stackTrace': stackTrace},
  );
}
