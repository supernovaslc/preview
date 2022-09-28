import 'package:flutter/material.dart';
import 'package:voice_chat_app/features/auth/screens/auth.dart';
import 'package:voice_chat_app/responsive/mobile_screen_layout.dart';
import 'package:voice_chat_app/responsive/responsive_layout.dart';
import 'package:voice_chat_app/responsive/web_screen_layout.dart';
import 'package:voice_chat_app/widgets/error.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AuthScreen(),
      );

    case ResponsiveLayout.routeName:
      return MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileLayoutScreen(),
          webScreenLayout: WebScreenLayout(),
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
