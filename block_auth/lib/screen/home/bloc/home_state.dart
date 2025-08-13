part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class LogoutLoading extends HomeState {}

final class LogoutSuccess extends HomeState {}

final class LogoutFailure extends HomeState {
  final String error;
  LogoutFailure(this.error);

  List<Object?> get props => [error];
}


