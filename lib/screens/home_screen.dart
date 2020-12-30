import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_camera_button_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  /// Shown when the app starts
  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.homeScreen));
    return Scaffold(
      backgroundColor: my_colors.blue,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SolveWithCameraButtonWidget(),
              _getTweenScaleAnimation(),
              _getTweenAlignmentAnimation(),
              _getTweenColorAnimation(),
              _getTweenSizeAnimation(),
              _getTweenSequenceAnimation(),
              _getTweenRotationAnimation(),
              _getCurveAnimation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTweenScaleAnimation() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1, end: 2),
      duration: Duration(seconds: 1),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        margin: EdgeInsets.all(16),
        color: my_colors.pink,
        child: Text('TweenScale'),
      ),
    );
  }

  Widget _getTweenAlignmentAnimation() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Text('?'),
    );
  }

  Widget _getTweenColorAnimation() {
    final Animation colorTween = ColorTween(begin: Colors.red, end: Colors.orange).animate(_animationController);
    return AnimatedBuilder(
      animation: colorTween,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(16),
          color: colorTween.value,
          child: Text('TweenColor'),
        );
      },
    );
  }

  Widget _getTweenSizeAnimation() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Text('?'),
    );
  }

  Widget _getTweenSequenceAnimation() {
    Animation<double> _waveEffectOpacity = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          weight: 60.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 0.0),
          weight: 40.0,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    Animation<double> _waveEffectSize = Tween(begin: 20.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: _waveEffectOpacity.value,
            child: Container(
              color: my_colors.grey,
              height: _waveEffectSize.value,
              width: _waveEffectSize.value,
              child: Text('TweenSequence'),
            ),
          ),
        );
      },
    );
  }

  Widget _getTweenRotationAnimation() {
    return AnimatedBuilder(
      animation: _animationController.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 2 * pi,
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        color: my_colors.red,
        child: Text('TweenRotation'),
      ),
    );
  }

  Widget _getCurveAnimation() {
    final Animation curveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
      reverseCurve: Curves.bounceIn,
    );
    return AnimatedBuilder(
      animation: curveAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(16),
          width: curveAnimation.value*360,
          height: curveAnimation.value*720,
          color: my_colors.black,
          child: Text('CurveAnimation'),
        );
      },
    );
  }
}
