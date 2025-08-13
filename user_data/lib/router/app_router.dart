import 'package:flutter/material.dart';
import 'package:user_data/router/router.dart';
import 'package:user_data/screen/home/home_screen.dart';
import 'package:user_data/screen/profile/profile_screen.dart';
import 'package:user_data/screen/signup/signup_screen.dart';
import 'package:user_data/screen/splash.dart';
import '../screen/signin/signin_screen.dart';
import '../database/user_model.dart';

class AppRouter {
  static Map<String, WidgetBuilder> appRoutes = {
    Routes.signIn: (context) => SignInScreen(),
    Routes.signUp: (context) => SignUpScreen(),
    Routes.mainHome: (context) => MainHomeScreen(userEmail: ''),
    Routes.splash: (context) => SplashScreen(),

    Routes.profile: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is String) {
        return ProfileScreen(email: args);
      } else {
        return const Scaffold(
          body: Center(child: Text('No email provided')),
        );
      }
    },

  };
}
