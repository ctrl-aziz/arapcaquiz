import 'package:flutter/material.dart';

class CustomNavigator {

  static Future pushReplacement(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page,
        transitionsBuilder: (c, anim, a2, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: anim.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  static Future push(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page,
        transitionsBuilder: (c, anim, a2, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: anim.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

}
