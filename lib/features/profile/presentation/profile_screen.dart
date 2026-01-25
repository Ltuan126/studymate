import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/features/profile/presentation/personal_info_screen.dart';
import 'package:studymate/features/profile/presentation/change_password_screen.dart';
import 'package:studymate/features/auth/state/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onNavigateToFocus;

  const ProfileScreen({super.key, this.onNavigateToFocus});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  final _authController = AuthController();

  // Định nghĩa menu items - dễ thêm/sửa/xóa
  List<_MenuItem> get _menuItems => [
    _MenuItem(
      icon: Icons.person,
      color: Colors.blue.shade400,
      label: 'Thông tin cá nhân',
      onTap: () => _navigateTo(const PersonalInfoScreen()),
    ),
    _MenuItem(
      icon: Icons.lock,
      color: Colors.amber.shade600,
      label: 'Thay đổi mật khẩu',
      onTap: () => _navigateTo(const ChangePasswordScreen()),
    ),
    _MenuItem(
      icon: Icons.cloud,
      color: Colors.blue.shade200,
      label: 'Sao lưu dữ liệu',
      onTap: _showComingSoon,
    ),
    _MenuItem(
      icon: Icons.hourglass_bottom,
      color: Colors.brown,
      label: 'Thời gian tập trung',
      onTap: widget.onNavigateToFocus,
    ),
    _MenuItem(
      icon: Icons.notifications,
      color: Colors.amber.shade700,
      label: 'Thông báo nhắc nhở',
      onTap: _showComingSoon,
    ),
    _MenuItem(
      icon: Icons.nights_stay,
      color: Colors.amber.shade300,
      label: 'Chế độ nền tối',
      onTap: _showComingSoon,
    ),
    _MenuItem(
      icon: Icons.help,
      color: Colors.redAccent,
      label: 'Trợ giúp & phản hồi',
      onTap: _showComingSoon,
    ),
  ];

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.construction, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text('Tính năng đang phát triển'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF6347E5),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await _authController.logout();
    if (!mounted) return;
    // Clear navigation stack và về màn hình gốc (StreamBuilder sẽ xử lý)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isLoggingOut) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            _buildAvatar(),
            const SizedBox(height: 24),
            _buildUserName(user),
            const SizedBox(height: 40),
            _buildMenuList(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB2B2).withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB2B2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserName(User user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String name =
            user.displayName ?? user.email?.split('@').first ?? 'Người dùng';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final firestoreName = data['name'] as String?;
          if (firestoreName != null && firestoreName.trim().isNotEmpty) {
            name = firestoreName;
          }
        }

        return Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        );
      },
    );
  }

  Widget _buildMenuList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _ProfileItem(
            icon: item.icon,
            iconColor: item.color,
            text: item.label,
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoggingOut ? null : _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6347E5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoggingOut
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Đăng xuất',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

// Data class cho menu items
class _MenuItem {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });
}

// Widget cho từng item trong menu
class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 260,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
