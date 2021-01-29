import 'package:flutter/material.dart';

class SlideAnimatedRoute extends PageRouteBuilder<RouteSettings> {
  final Widget nextPage;
  final RouteSettings routeSettings;

  SlideAnimatedRoute({this.nextPage, this.routeSettings})
      : super(
          settings: routeSettings,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) => nextPage,
          transitionsBuilder: (BuildContext _, Animation<double> animation, Animation<double> __, Widget child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
