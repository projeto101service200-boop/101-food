enum UserRole { customer, restaurant, rider, admin }
enum UserStatus { active, blocked, pending }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final UserRole role;
  final UserStatus status;
  final String? fcmToken;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.status,
    this.fcmToken,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      role: UserRole.values.firstWhere((e) => e.name == map['role'], orElse: () => UserRole.customer),
      status: UserStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => UserStatus.pending),
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
      'status': status.name,
      'fcmToken': fcmToken,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
