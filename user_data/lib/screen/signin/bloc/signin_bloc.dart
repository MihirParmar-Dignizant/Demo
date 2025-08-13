import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_data/database/database_helper.dart';
import 'package:user_data/database/user_model.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInRequested>(_onSignInRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event,
      Emitter<SignInState> emit,
      ) async {
    emit(SignInLoading());
    try {
      final dbHelper = DatabaseHelper.instance;
      final user = await dbHelper.getUserByEmail(event.email);

      if (user == null) {
        emit(SignInFailure("No account found with this email"));
        return;
      }

      if (user.password != event.password) {
        emit(SignInFailure("Incorrect password"));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInEmail', user.email);


      // Success → you can emit email or id
      emit(SignInSuccess(user.email));
    } catch (e) {
      emit(SignInFailure("An error occurred while signing in"));
    }
  }
}
