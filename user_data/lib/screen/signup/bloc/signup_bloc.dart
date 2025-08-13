import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_data/database/user_model.dart';
import '../../../database/database_helper.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final DatabaseHelper dbHelper;

  SignUpBloc({required this.dbHelper}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event,
      Emitter<SignUpState> emit,
      ) async {
    emit(SignUpLoading());
    try {
      final existingUser = await dbHelper.getUserByEmail(event.user.email);
      if (existingUser != null) {
        emit(SignUpFailure("Email already exists."));
        return;
      }
      await dbHelper.insertUser(event.user);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
