import 'package:elearning_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final bool isLoading;
  final String? error;

  const AuthState({this.userModel, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? userModel, bool? isLoading, String? error}) {
    return AuthState(
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userModel, isLoading, error];
}
