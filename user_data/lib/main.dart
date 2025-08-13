import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_data/router/app_router.dart';
import 'package:user_data/router/router.dart';
import 'package:user_data/screen/profile/bloc/profile_bloc.dart';
import 'package:user_data/screen/signin/bloc/signin_bloc.dart';
import 'package:user_data/screen/signup/bloc/signup_bloc.dart';
import 'package:user_data/theme/theme_bloc.dart';
import 'package:user_data/theme/theme_state.dart';

import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc(dbHelper: DatabaseHelper.instance)),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => ProfileBloc(DatabaseHelper.instance)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'User Profile',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            initialRoute: Routes.initial,
            routes: AppRouter.appRoutes,
          );
        },
      ),
    );
  }
}
