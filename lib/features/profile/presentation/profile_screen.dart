import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studymate/features/profile/presentation/personal_info_screen.dart';
import 'package:studymate/features/profile/presentation/change_password_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Bạn';
    return user.displayName ?? user.email?.split('@').first ?? 'Bạn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.pinkAccent.shade100,
              child: const Icon(Icons.person, size: 56, color: Colors.white),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              _getUserName(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _ProfileItem(
                    icon: Icons.person_outline,
                    text: 'Thông tin cá nhân',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  PersonalInfoScreen(),
                        ),
                      );
                    },
                  ),
                  _ProfileItem(
                        icon: Icons.lock_outline,
                        text: 'Thay đổi mật khẩu',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),

                  const _ProfileItem(
                    icon: Icons.cloud_outlined,
                    text: 'Sao lưu dữ liệu',
                  ),
                  const _ProfileItem(
                    icon: Icons.hourglass_bottom,
                    text: 'Thời gian tập trung',
                  ),
                  const _ProfileItem(
                    icon: Icons.notifications_none,
                    text: 'Thông báo nhắc nhở',
                  ),
                  const _ProfileItem(
                    icon: Icons.dark_mode_outlined,
                    text: 'Chế độ nền tối',
                  ),
                  const _ProfileItem(
                    icon: Icons.help_outline,
                    text: 'Trợ giúp & phản hồi',
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 15)),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
