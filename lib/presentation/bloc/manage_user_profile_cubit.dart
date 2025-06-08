import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/services/models/user_profile_model.dart';
import 'package:flutter_platter/services/repository/firebase_db_repository.dart';

part 'manage_user_profile_state.dart';

class ManageUserProfileCubit extends Cubit<ManageUserProfileState> {
  ManageUserProfileCubit(this.firebaseDBRepository)
    : super(ManageUserProfileCubitInitial());
  final FirebaseDBRepository firebaseDBRepository;

  void addUserProfile(Map<String, dynamic> userDetails) async {
    emit(ManageUserProfileLoading());
    try {
      await firebaseDBRepository.addUserProfile(userDetails);
      emit(const AddUserProfileLoaded());
    } catch (e) {
      emit(ManageUserProfileError(message: e.toString()));
    }
  }

  void getUserProfile() async {
    emit(ManageUserProfileLoading());
    try {
      final data = await firebaseDBRepository.getUserProfile();
      emit(GetUserProfileLoaded(userProfile: data));
    } catch (e) {
      emit(ManageUserProfileError(message: e.toString()));
    }
  }
}
