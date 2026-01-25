// lib/features/home/presentation/home_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymate/core/theme/app_theme.dart';
import 'package:studymate/features/focus/presentation/focus_screen.dart';
import 'package:studymate/features/calendar/presentation/calendar_screen.dart';
import 'package:studymate/features/focus/domain/focus_timer.dart';
import 'package:studymate/features/profile/presentation/profile_screen.dart';
import 'package:studymate/features/tasks/presentation/add_edit_task_screen.dart';
import 'package:studymate/features/tasks/presentation/task_list_screen.dart';
import 'widgets/dashboard_widgets.dart';
import 'widgets/bottom_navigation.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;

  void _switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isFocusTab = _currentIndex == 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isFocusTab
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: isFocusTab
            ? const Color(0xFF0E0E12)
            : Colors.white,
        systemNavigationBarIconBrightness: isFocusTab
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _DashboardContent(onNavigateToFocus: () => _switchToTab(1)),
            FocusScreen(key: const ValueKey('focus')),
            const CalendarScreen(),
            ProfileScreen(onNavigateToFocus: () => _switchToTab(1)),
          ],
        ),
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _switchToTab,
        ),
      ),
    );
  }
}

/// ================= DASHBOARD CONTENT =================

class _DashboardContent extends StatelessWidget {
  final VoidCallback onNavigateToFocus;

  const _DashboardContent({required this.onNavigateToFocus});

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Bạn';
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
    final focusTimer = FocusTimer.instance;
    final userName = _getUserName();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
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
              const DashboardAvatar(),
              const SizedBox(height: 18),
              _buildGreeting(userName),
              const SizedBox(height: 6),
              Text(
                'Hôm nay bạn muốn học gì?',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 28),
              const ProgressCard(
                title: 'Tiến độ tuần này',
                color: AppColors.cardGrey,
                activeColor: AppColors.primaryDark,
              ),
              const SizedBox(height: 22),
              _buildStatCards(context, focusTimer),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(String fallbackName) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String name = fallbackName;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? fallbackName;
        }
        return Text(
          'Xin chào $name, 👋',
          style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800),
        );
      },
    );
  }

  Widget _buildStatCards(BuildContext context, FocusTimer focusTimer) {
    return Row(
      children: [
        // Focus Card
        Expanded(
          child: GestureDetector(
            onTap: onNavigateToFocus,
            child: AnimatedBuilder(
              animation: focusTimer,
              builder: (_, child) {
                return StatCard(
                  color: AppColors.primaryDark,
                  label: focusTimer.formattedTime,
                  sub: 'Focus',
                  icon: focusTimer.isRunning
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Tasks Card
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
              final progress = total > 0 ? done / total : 0.0;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TaskListScreen()),
                  );
                },
                child: StatCard(
                  color: AppColors.accent,
                  label: '$done/$total',
                  sub: 'Bài tập',
                  icon: Icons.assignment_rounded,
                  progress: progress,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
