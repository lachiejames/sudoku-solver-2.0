import 'package:flutter/material.dart';

class SizeAnimatedRoute extends PageRouteBuilder<RouteSettings> {
  final Widget nextPage;
  final RouteSettings routeSettings;

  SizeAnimatedRoute({this.nextPage, this.routeSettings})
      : super(
          settings: routeSettings,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) => nextPage,
          transitionsBuilder: (BuildContext _, Animation<double> animation, Animation<double> __, Widget child) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}
