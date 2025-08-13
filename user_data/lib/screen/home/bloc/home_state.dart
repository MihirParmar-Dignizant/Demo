part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeLoaded extends HomeState {
  final UserModelData user;
  HomeLoaded(this.user);
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
