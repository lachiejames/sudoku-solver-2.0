import 'package:camera/camera.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/home_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

Future<void> main() async {
  // Allows us to run integration tests
  enableFlutterDriverExtension(handler: (dynamic command) async {
    if (command == 'restart') {
      await restartApp();
    } else {
      await setMock(command);
    }
    return 'ok';
  });

  await restartApp();
}

Future<void> _initCamera() async {
  List<CameraDescription> cameras;
  CameraController cameraController;

  try {
    cameras = await availableCameras();
  } on Exception catch (e) {
    await logError('ERROR: camera not found', e);
    return;
  }

  cameraController = CameraController(cameras.first, ResolutionPreset.max, enableAudio: false);

  try {
    await cameraController.initialize();
  } on Exception catch (e) {
    await logError('ERROR: camera could not be initialised', e);
    return;
  }

  Redux.store.dispatch(CameraReadyAction(cameraController));
}

/// Builds/rebuilds the app
Future<void> restartApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true); // send crash reports during debugging
  await FirebaseAdMob.instance.initialize(appId: appIdForAdMob);

  await Redux.init();
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.setInt(gameNumberSharedPrefsKey, 0);
  await _initCamera();
  await loadSoundsToCache();

  runApp(
    MyApp(
      key: UniqueKey(),
    ),
  );
}

/// Base widget for the app
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setScreenProperties(context);
    return StoreProvider<AppState>(
      store: Redux.store,
      child: MaterialApp(
        title: 'Sudoku Solver',
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
        ],
        theme: ThemeData(
          primaryColor: blue,
          backgroundColor: pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }

  /// Gets default clutter off of the screen
  void setScreenProperties(BuildContext context) {
    // Remove status bar and system navigation bar
    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    // Prevent screen rotation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
}
