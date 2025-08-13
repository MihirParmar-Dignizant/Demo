import 'package:equatable/equatable.dart';
import 'package:user_data/database/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModelData user;
  final bool isEditing;

  ProfileLoaded({required this.user, this.isEditing = false});

  ProfileLoaded copyWith({UserModelData? user, bool? isEditing}) {
    return ProfileLoaded(
      user: user ?? this.user,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [user, isEditing];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
