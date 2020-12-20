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
import 'package:sudoku_solver_2/constants/mocks.dart';
import 'package:sudoku_solver_2/constants/my_ad_helper.dart' as my_ad_helper;
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/home_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

Future<void> main() async {
  // Allows us to run integration tests
  enableFlutterDriverExtension(handler: (command) async {
    if (command == my_strings.hotRestart) {
      await restartApp();
      return 'ok';
    } else if (command == my_strings.setPictureMock) {
      await MyMockHelper.setPictureMock();
      return 'ok';
    } else if (command == my_strings.deletePictureMock) {
      await MyMockHelper.deletePictureMock();
      return 'ok';
    }
    throw Exception('Unknown command: $command');
  });

  await restartApp();
}

Future<void> _initCamera() async {
  try {
    List<CameraDescription> cameras = await availableCameras();
    CameraController cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await cameraController.initialize();
    Redux.store.dispatch(CameraReadyAction(cameraController));
  } on Exception catch (e) {
    print(e);
  }
}

/// Builds/rebuilds the app
Future<void> restartApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true); // send crash reports during debugging
  await FirebaseAdMob.instance.initialize(appId: my_ad_helper.appIdForAdMob);

  await Redux.init();
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.setInt(my_strings.gameNumberSharedPrefsKey, 0);
  await _initCamera();

  runApp(
    MyApp(
      key: UniqueKey(),
    ),
  );
}

/// Base widget for the app
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.setScreenProperties(context);
    return StoreProvider<AppState>(
      store: Redux.store,
      child: MaterialApp(
        title: 'Sudoku Solver',
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(analytics: my_values.firebaseAnalytics),
        ],
        theme: ThemeData(
          primaryColor: my_colors.blue,
          backgroundColor: my_colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }

  /// Gets default clutter off of the screen
  void setScreenProperties(BuildContext context) {
    // Remove status bar and system navigation bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    // Prevent screen rotation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
}
