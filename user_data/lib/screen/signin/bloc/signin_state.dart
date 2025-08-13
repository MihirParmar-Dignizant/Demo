part of 'signin_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String userEmail;
  SignInSuccess(this.userEmail);
}

class SignInFailure extends SignInState {
  final String message;
  SignInFailure(this.message);
}
