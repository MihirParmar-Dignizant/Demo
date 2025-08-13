part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadUserData extends HomeEvent {
  final String email;
  LoadUserData(this.email);
}
