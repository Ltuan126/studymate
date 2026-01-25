// lib/features/home/presentation/home_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymate/features/focus/presentation/focus_screen.dart';
import 'package:studymate/features/calendar/presentation/calendar_screen.dart';
import 'package:studymate/features/focus/domain/focus_timer.dart';
import 'package:studymate/features/profile/profile_screen.dart';
import 'package:studymate/features/tasks/presentation/add_edit_task_screen.dart';
import 'package:studymate/features/tasks/presentation/task_list_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const _DashboardContent(),
          FocusScreen(key: const ValueKey('focus')),
          const CalendarScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

/// ================= DASHBOARD UI =================

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Bạn';
    // Lấy phần trước @ của email làm tên
    final email = user.email ?? '';
    final name = email.split('@').first;
    return name.isNotEmpty ? name : 'Bạn';
  }

  Stream<QuerySnapshot>? _getTasksStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F6F8);
    const card = Color(0xFFE1E1E4);
    const primary = Color(0xFF4B42D6);
    const accent = Color(0xFFF59E0B);
    const muted = Color(0xFF7C7C86);

    final focusTimer = FocusTimer.instance;
    final userName = _getUserName();

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Avatar(),
              const SizedBox(height: 18),
              Text(
                'Xin chào $userName, 👋',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Hôm nay bạn muốn học gì?',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 28),
              const _ProgressCard(
                title: 'Tiến độ tuần này',
                color: card,
                activeColor: primary,
              ),
              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: focusTimer,
                      builder: (_, child) {
                        return _StatCard(
                          color: primary,
                          label: focusTimer.formattedTime,
                          sub: 'Focus',
                          icon: focusTimer.isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _getTasksStream(),
                      builder: (context, snapshot) {
                        final tasks = snapshot.data?.docs ?? [];
                        final total = tasks.length;
                        final done = tasks.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['isDone'] == true;
                        }).length;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TaskListScreen(),
                              ),
                            );
                          },
                          child: _StatCard(
                            color: accent,
                            label: '$done/$total',
                            sub: 'Bài tập',
                            icon: Icons.assignment_rounded,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= COMPONENTS =================

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF9EB5), Color(0xFFFFC2A0)],
        ),
      ),
      child: const Center(
        child: Text('🧑🏻‍🎓', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color activeColor;

  const _ProgressCard({
    required this.title,
    required this.color,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              final isActive = index == 6;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 20,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? activeColor
                      : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color color;
  final String label;
  final String sub;
  final IconData icon;

  const _StatCard({
    required this.color,
    required this.label,
    required this.sub,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= BOTTOM NAV =================

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(
            icon: Icons.home_rounded,
            active: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIcon(
            icon: Icons.qr_code_scanner_rounded,
            active: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavIcon(
            icon: Icons.calendar_month_rounded,
            active: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavIcon(
            icon: Icons.person_outline_rounded,
            active: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  static const primary = Color(0xFF4B42D6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active ? primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: active ? primary : primary.withValues(alpha: 0.6),
          size: 22,
        ),
      ),
    );
  }
}
