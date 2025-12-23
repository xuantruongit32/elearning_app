import 'dart:async';

import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_state.dart';
import 'package:elearning_app/bloc/profile/profile_event.dart';
import 'package:elearning_app/bloc/profile/profile_state.dart';
import 'package:elearning_app/models/profile.dart';
import 'package:elearning_app/respositories/auth_respository.dart';
import 'package:elearning_app/services/cloudinary_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final AuthRepository _authRepository;
  late final StreamSubscription<AuthState> _authSubscription;
  final CloudinaryService _cloudinaryService;

  ProfileBloc({
    required AuthBloc authBloc,
    CloudinaryService? cloudinaryService,
    AuthRepository? authRepository,
  }) : _authBloc = authBloc,
       _authRepository = authRepository ?? AuthRepository(),
       _cloudinaryService = cloudinaryService ?? CloudinaryService(),
       super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UpdateProfilePhotoRequested>(_onUpdateProfilePhotoRequested);

    //load profile when aut state changes
    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.userModel != null) {
        add(LoadProfile());
      }
    });
    //initial load if user logged in
    if (_authBloc.state.userModel != null) {
      add(LoadProfile());
    }
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
          phoneNumber: userModel.phoneNumber,
          bio: userModel.bio,
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
        phoneNumber: event.phoneNumber,
        bio: event.bio,
      );

      if (state.profile != null) {
        final updatedProfile = state.profile!.copyWith(
          fullName: event.fullName,
          photoUrl: event.photoUrl,
          phoneNumber: event.phoneNumber,
          bio: event.bio,
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

      //upload to cloudinary

      final photoUrl = await _cloudinaryService.uploadImage(
        event.photoPath,
        'profile_pictures',
      );

      //update profile with new photo url
      add(UpdateProfileRequested(photoUrl: photoUrl));

      emit(state.copyWith(isPhotoUploading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isPhotoUploading: false));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
