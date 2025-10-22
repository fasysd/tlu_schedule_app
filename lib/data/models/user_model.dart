class UserModel {
  final String id;
  final String username;
  final String password;
  final String email;
  final String role;
  final String fullName;
  final String avatarPath;
  final String phone;
  final DateTime? dateOfBirth;
  final String? departmentId;
  final String warningStatus;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.fullName,
    required this.avatarPath,
    required this.phone,
    this.dateOfBirth,
    this.departmentId,
    this.warningStatus = 'none',
  });

  factory UserModel.empty() {
    return UserModel(
      id: '',
      username: '',
      password: '',
      email: '',
      phone: '',
      role: '',
      fullName: '',
      avatarPath: '',
      warningStatus: 'none',
    );
  }

  UserModel copyWith({
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
  }) {
    return UserModel(
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
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      fullName: json['fullName'] ?? '',
      avatarPath: json['avatarPath'] ?? '',
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      departmentId: json['departmentId'],
      warningStatus: json['warningStatus'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'role': role,
      'fullName': fullName,
      'avatarPath': avatarPath,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'departmentId': departmentId,
      'warningStatus': warningStatus,
    };
  }
}
