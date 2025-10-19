import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final String? fullName;
  final String? phoneNumber;
  final String? bio;
  final String? photoUrl;

  const UpdateProfileRequested({
    this.fullName,
    this.phoneNumber,
    this.bio,
    this.photoUrl,
  });
  @override
  List<Object?> get props => [fullName, phoneNumber, bio, photoUrl];
}

class UpdateProfilePhotoRequested extends ProfileEvent {
  final String photoPath;

  const UpdateProfilePhotoRequested(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}
