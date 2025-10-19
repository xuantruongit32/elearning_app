import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? fullName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserRole role;
  final String? bio;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    this.bio,
    this.phoneNumber,
    required this.email,
    this.fullName,
    this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.role,
  });
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      bio: data['bio'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.student,
      ),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'role': role.name,
      'phoneNumber': phoneNumber,
      'bio': bio,
    };
  }
}

enum UserRole { student, teacher }
