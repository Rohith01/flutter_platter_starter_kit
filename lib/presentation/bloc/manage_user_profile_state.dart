part of 'manage_user_profile_cubit.dart';

abstract class ManageUserProfileState extends Equatable {
  const ManageUserProfileState();

  @override
  List<Object> get props => [];
}

class ManageUserProfileCubitInitial extends ManageUserProfileState {}

class ManageUserProfileLoading extends ManageUserProfileState {}

class AddUserProfileLoaded extends ManageUserProfileState {
  const AddUserProfileLoaded();
}

class GetUserProfileLoaded extends ManageUserProfileState {
  const GetUserProfileLoaded({required this.userProfile});
  final UserProfile userProfile;
  @override
  List<Object> get props => [userProfile];
}

class ManageUserProfileError extends ManageUserProfileState {
  const ManageUserProfileError({
    required this.message,
  });
  final String message;

  @override
  List<Object> get props => [message];
}
