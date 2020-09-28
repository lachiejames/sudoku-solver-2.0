import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/home_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  // Allows us to run integration tests
  enableFlutterDriverExtension(handler: (command) async {
    if (command == my_strings.hotRestart) {
      await restartApp();
      return 'ok';
    }
    throw Exception('Unknown command');
  });

  await restartApp();
}

/// Builds/rebuilds the app
Future<void> restartApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Redux.init();
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setInt('sudoku_solver_game_number', 0);

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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
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
