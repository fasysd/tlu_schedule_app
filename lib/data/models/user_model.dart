class UserAccount {
  final String id;
  final String username;
  final String password;
  final String role;
  final String fullName;
  final String avatarPath;
  final String? departmentId;

  UserAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.fullName,
    required this.avatarPath,
    this.departmentId,
  });
}
