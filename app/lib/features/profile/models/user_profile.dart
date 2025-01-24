import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String? displayName;
  final String? photoURL;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.displayName,
    this.photoURL,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  // Create from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      displayName: data['displayName'] as String?,
      photoURL: data['photoURL'] as String?,
      bio: data['bio'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create a copy of UserProfile with some fields updated
  UserProfile copyWith({
    String? displayName,
    String? photoURL,
    String? bio,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      bio: json['bio'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
