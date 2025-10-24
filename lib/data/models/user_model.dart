class UserAccount {
  final String id;
  final String username;
  final String password;
  final String email;
  final String role;
  final String fullName;
  final String avatarPath;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? departmentId;
  final String warningStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.fullName,
    required this.avatarPath,
    this.dateOfBirth,
    this.phone,
    this.departmentId,
    this.warningStatus = 'none',
    this.createdAt,
    this.updatedAt,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'role': role,
      'fullName': fullName,
      'avatarPath': avatarPath,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'departmentId': departmentId,
      'warningStatus': warningStatus,
      'createdAt': createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create from Map (Firebase document)
  factory UserAccount.fromMap(Map<String, dynamic> map, String id) {
    return UserAccount(
      id: id,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      fullName: map['fullName'] ?? '',
      avatarPath: map['avatarPath'] ?? 'assets/images/defaultAvatar.png',
      phone: map['phone'],
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth']) 
          : null,
      departmentId: map['departmentId'],
      warningStatus: map['warningStatus'] ?? 'none',
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) 
          : null,
    );
  }

  // Create a copy with updated fields
  UserAccount copyWith({
    String? id,
    String? username,
    String? password,
    String? email,
    String? role,
    String? fullName,
    String? avatarPath,
    String? phone,
    DateTime? dateOfBirth,
    String? departmentId,
    String? warningStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAccount(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      avatarPath: avatarPath ?? this.avatarPath,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      departmentId: departmentId ?? this.departmentId,
      warningStatus: warningStatus ?? this.warningStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
