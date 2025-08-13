import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
    ThemeState(
      themeData: ThemeData.light(),
      isDarkMode: false,
    ),
  ) {
    on<ToggleThemeEvent>((event, emit) {
      if (state.isDarkMode) {
        emit(ThemeState(themeData: ThemeData.light(), isDarkMode: false));
      } else {
        emit(ThemeState(themeData: ThemeData.dark(), isDarkMode: true));
      }
    });
  }
}
