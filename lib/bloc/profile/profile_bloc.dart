import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/profile/profile_event.dart';
import 'package:elearning_app/bloc/profile/profile_state.dart';
import 'package:elearning_app/models/profile.dart';
import 'package:elearning_app/respositories/auth_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final AuthRepository _authRepository;

  ProfileBloc({required AuthBloc authBloc, AuthRepository? authRepository})
    : _authBloc = authBloc,
      _authRepository = authRepository ?? AuthRepository(),
      super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UpdateProfilePhotoRequested>(_onUpdateProfilePhotoRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final userModel = _authBloc.state.userModel;

      if (userModel != null) {
        final profile = ProfileModel(
          fullName: userModel.fullName ?? '',
          email: userModel.email,
          photoUrl: userModel.photoUrl,
          stats: const ProfileStats(
            coursesCount: 0,
            hoursSpent: 0,
            successRate: 0,
          ),
        );
        emit(state.copyWith(isLoading: false, profile: profile));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    //firebase later
    try {
      emit(state.copyWith(isLoading: true));

      await _authRepository.updateProfile(
        fullName: event.fullName,
        photoUrl: event.photoUrl,
      );

      if (state.profile != null) {
        final updatedProfile = state.profile!.copyWith(
          fullName: event.fullName,
          photoUrl: event.photoUrl,
        );
        emit(state.copyWith(isLoading: false, profile: updatedProfile));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProfilePhotoRequested(
    UpdateProfilePhotoRequested event,
    Emitter<ProfileState> emit,
  ) async {
    //firebase later
    try {
      emit(state.copyWith(isLoading: true));
    } catch (e) {}
  }
}
