part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final UserModelData user;
  SignUpSubmitted(this.user);
}
