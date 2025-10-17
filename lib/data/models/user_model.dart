class UserAccount {
  final String id;
  final String username;
  final String password;
  final String email;
  final String role;
  final String fullName;
  final String avatarPath;
  final String? departmentId;
  final String warningStatus;

  UserAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.fullName,
    required this.avatarPath,
    this.departmentId,
    this.warningStatus = 'none',
  });
}
