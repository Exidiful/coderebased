import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String studentId;
  String? firstName;
  String? lastName;
  String? profileImageUrl;
  String? phoneNumber;
  String? bio;
  List<String>? skills;
  List<String>? programmingLanguages;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.studentId,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.phoneNumber,
    this.bio,
    this.skills,
    this.programmingLanguages,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: data['id'] as String,
      email: data['email'] as String,
      studentId: data['studentId'] as String,
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      bio: data['bio'] as String?,
      skills: (data['skills'] as List<dynamic>?)?.cast<String>(),
      programmingLanguages:
          (data['programmingLanguages'] as List<dynamic>?)?.cast<String>(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'skills': skills,
      'programmingLanguages': programmingLanguages,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
