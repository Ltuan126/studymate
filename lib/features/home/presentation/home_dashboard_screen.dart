import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F6F8);
    const card = Color(0xFFE1E1E4);
    const primary = Color(0xFF4B42D6);
    const accent = Color(0xFFF59E0B);
    const muted = Color(0xFF7C7C86);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F8FA),
                    Color(0xFFF1F2F6),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF4B42D6).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _Avatar(),
                  const SizedBox(height: 18),
                  Text(
                    'Xin chào Nam, 👋',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
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
                  _ProgressCard(
                    title: 'Tiến độ tuần này',
                    color: card,
                    activeColor: primary,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          color: primary,
                          label: '25:00',
                          sub: ' ',
                          icon: Icons.play_arrow_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          color: accent,
                          label: '4/5',
                          sub: 'Bài tập',
                          icon: Icons.assignment_rounded,
                          showProgress: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _Avatar extends StatelessWidget {
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
        child: Text(
          '🧑🏻‍🎓',
          style: TextStyle(fontSize: 22),
        ),
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
    final bars = List.generate(7, (index) => index);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bars.map((index) {
              final isActive = index == bars.length - 1;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 20,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
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
  final bool showProgress;

  const _StatCard({
    required this.color,
    required this.label,
    required this.sub,
    required this.icon,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 26),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (sub.trim().isNotEmpty)
            Text(
              sub,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          if (showProgress) ...[
            const SizedBox(height: 10),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4B42D6);

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
          _NavIcon(icon: Icons.home_rounded, active: true, color: primary),
          _NavIcon(icon: Icons.qr_code_scanner_rounded, color: primary),
          _NavIcon(icon: Icons.calendar_month_rounded, color: primary),
          _NavIcon(icon: Icons.person_outline_rounded, color: primary),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color color;

  const _NavIcon({
    required this.icon,
    this.active = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: active ? color : color.withOpacity(0.6),
        size: 22,
      ),
    );
  }
}
