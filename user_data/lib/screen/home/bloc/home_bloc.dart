import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_data/database/database_helper.dart';
import 'package:user_data/database/user_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
      LoadUserData event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      final dbHelper = DatabaseHelper.instance;
      final user = await dbHelper.getUserByEmail(event.email);

      if (user != null) {
        emit(HomeLoaded(user));
      } else {
        emit(HomeError("User not found"));
      }
    } catch (e) {
      emit(HomeError("Failed to load user data"));
    }
  }
}
