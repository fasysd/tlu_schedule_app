import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/warning_helper.dart';

class CommonHeader extends StatelessWidget {
  final UserAccount user;
  final Widget? trailing;
  final VoidCallback? onLogout;

  const CommonHeader({
    super.key,
    required this.user,
    this.trailing,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final warningDetails = getWarningDetails(user.warningStatus);
    final warningText = warningDetails['text'];
    final warningColor = warningDetails['color'];

    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(89, 141, 192, 1),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(user.avatarPath),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giảng viên",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, color: warningColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      warningText,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onLogout != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onLogout,
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tooltip: 'Đăng xuất',
            ),
          ],
        ],
      ),
    );
  }
}
