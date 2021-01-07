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
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/home_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

Future<void> main() async {
  // Allows us to run integration tests
  enableFlutterDriverExtension(handler: (command) async {
    if (command == constants.hotRestart) {
      await restartApp();
      return 'ok';
    } else if (command == constants.setVeryHighResPictureMockString) {
      await constants.setVeryHighResPictureMock();
      return 'ok';
    } else if (command == constants.setHighResPictureMockString) {
      await constants.setHighResPictureMock();
      return 'ok';
    } else if (command == constants.setMediumResPictureMockString) {
      await constants.setMediumResPictureMock();
      return 'ok';
    } else if (command == constants.deleteAllMocksString) {
      await constants.deleteAllMocks();
      return 'ok';
    } else if (command == constants.setCameraNotFoundErrorMockString) {
      await constants.setCameraNotFoundErrorMock();
      return 'ok';
    } else if (command == constants.setPhotoProcessingErrorMockString) {
      await constants.setPhotoProcessingErrorMock();
      return 'ok';
    } else if (command == constants.setTimeoutErrorPictureMockString) {
      await constants.setTimeoutErrorPictureMock();
      return 'ok';
    } else if (command == constants.setInvalidErrorPictureMockString) {
      await constants.setInvalidErrorPictureMock();
      return 'ok';
    }
    throw Exception('Unknown command: $command');
  });

  await restartApp();
}

Future<void> _initCamera() async {
  try {
    List<CameraDescription> cameras = await availableCameras();
    CameraController cameraController = CameraController(cameras.first, ResolutionPreset.max);
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
  await FirebaseAdMob.instance.initialize(appId: constants.appIdForAdMob);

  await Redux.init();
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.setInt(constants.gameNumberSharedPrefsKey, 0);
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
          FirebaseAnalyticsObserver(analytics: constants.firebaseAnalytics),
        ],
        theme: ThemeData(
          primaryColor: constants.blue,
          backgroundColor: constants.pink,
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
