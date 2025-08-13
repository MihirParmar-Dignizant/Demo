part of 'signin_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignInRequested extends SignInEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}
