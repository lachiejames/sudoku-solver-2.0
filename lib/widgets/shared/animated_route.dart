import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget nextPage;
  final RouteSettings routeSettings;

  AnimatedRoute({this.nextPage, this.routeSettings})
      : super(
          settings: routeSettings,
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 300),
          pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) => nextPage,
          transitionsBuilder: (BuildContext _, Animation<double> animation, Animation<double> __, Widget child) {
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            );
          },
        );
}
