import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'constants/my_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Redux.sharedPreferences = await SharedPreferences.getInstance();
  Redux.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    this.setScreenProperties();
    return StoreProvider<AppState>(
      store: Redux.store,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: MyColors.blue,
          backgroundColor: MyColors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SolveWithCameraScreen(),
      ),
    );
  }

  void setScreenProperties() {
    // Remove status bar and system navigation bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    // Prevent screen rotation
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
}
