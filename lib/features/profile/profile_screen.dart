import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Bạn';
    return user.email?.split('@').first ?? 'Bạn';
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Menu
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: const [
                  _ProfileItem(
                    icon: Icons.person_outline,
                    text: 'Thông tin cá nhân',
                  ),
                  _ProfileItem(
                    icon: Icons.lock_outline,
                    text: 'Thay đổi mật khẩu',
                  ),
                  _ProfileItem(
                    icon: Icons.cloud_outlined,
                    text: 'Sao lưu dữ liệu',
                  ),
                  _ProfileItem(
                    icon: Icons.hourglass_bottom,
                    text: 'Thời gian tập trung',
                  ),
                  _ProfileItem(
                    icon: Icons.notifications_none,
                    text: 'Thông báo nhắc nhở',
                  ),
                  _ProfileItem(
                    icon: Icons.dark_mode_outlined,
                    text: 'Chế độ nền tối',
                  ),
                  _ProfileItem(
                    icon: Icons.help_outline,
                    text: 'Trợ giúp & phản hồi',
                  ),
                ],
              ),
            ),

            // Logout button
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

  const _ProfileItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
