import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_repository.dart';
import '../model/todo_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository) : super(HomeInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      emit(LogoutLoading());

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token?.isEmpty ?? true) {
          emit(LogoutFailure("No token found"));
          return;
        }

        await homeRepository.logout(token!);
        await prefs.remove('auth_token');
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure(e.toString()));
      }
    });

  }


}
