import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_data/database/database_helper.dart';
import 'package:user_data/database/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DatabaseHelper dbHelper;

  ProfileBloc(this.dbHelper) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ChangeProfilePicture>(_onChangeProfilePicture);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await dbHelper.getUserByEmail(event.email);
      if (user != null) {
        emit(ProfileLoaded(user: user, isEditing: false));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError("Error: $e"));
    }
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(current.copyWith(isEditing: !current.isEditing));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      try {
        await dbHelper.updateUser(event.updatedUser);
        emit(ProfileLoaded(user: event.updatedUser, isEditing: false));
      } catch (e) {
        emit(ProfileError("Failed to update user: $e"));
      }
    }
  }

  void _onChangeProfilePicture(
      ChangeProfilePicture event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updatedUser = current.user.copyWith(userPic: event.newPath);
      emit(current.copyWith(user: updatedUser));
    }
  }
}
