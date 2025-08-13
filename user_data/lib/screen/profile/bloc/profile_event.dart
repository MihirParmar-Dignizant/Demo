import 'package:equatable/equatable.dart';
import 'package:user_data/database/user_model.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final String email;
  LoadUserProfile(this.email);

  @override
  List<Object?> get props => [email];
}

class ToggleEditMode extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final UserModelData updatedUser;
  UpdateUserProfile(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

class ChangeProfilePicture extends ProfileEvent {
  final String newPath;
  ChangeProfilePicture(this.newPath);

  @override
  List<Object?> get props => [newPath];
}
