import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/focus_timer.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = FocusTimer.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: Stack(
        children: [
          // Background subtle pattern or gradient if needed
          Center(
            child: AnimatedBuilder(
              animation: timer,
              builder: (_, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    /// ===== CIRCLE TIMER =====
                    _GlowCircle(
                      progress: timer.progress,
                      timeText: timer.formattedTime,
                      isRunning: timer.isRunning,
                    ),

                    const SizedBox(height: 80),

                    /// ===== SLIDE TO STOP / START BUTTON =====
                    if (timer.isRunning)
                      _SlideToStop(onStop: timer.reset)
                    else
                      _StartButton(onStart: timer.start),

                    const SizedBox(height: 40),

                    /// ===== TIME SELECTION (only when not running) =====
                    if (!timer.isRunning)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TimeChip(
                            label: '-5',
                            onTap: () => timer.addMinutes(-5),
                          ),
                          _TimeChip(
                            label: '+5',
                            onTap: () => timer.addMinutes(5),
                          ),
                          _TimeChip(
                            label: '+25',
                            onTap: () => timer.addMinutes(25),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double progress;
  final String timeText;
  final bool isRunning;

  const _GlowCircle({
    required this.progress,
    required this.timeText,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4D47E5).withValues(alpha: 0.2),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),

          // Custom Painter for the progress arc
          CustomPaint(
            size: const Size(280, 280),
            painter: _ModernCirclePainter(progress: progress),
          ),

          // Central Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeText,
                style: GoogleFonts.manrope(
                  fontSize: 58,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              Text(
                isRunning ? 'Đang tập trung' : 'Sẵn sàng',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernCirclePainter extends CustomPainter {
  final double progress;
  _ModernCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF6C63FF), Color(0xFF4D47E5)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _StartButton extends StatelessWidget {
  final VoidCallback onStart;
  const _StartButton({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      child: Container(
        width: 180,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF4D47E5),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4D47E5).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Bắt đầu',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SlideToStop extends StatefulWidget {
  final VoidCallback onStop;
  const _SlideToStop({required this.onStop});

  @override
  State<_SlideToStop> createState() => _SlideToStopState();
}

class _SlideToStopState extends State<_SlideToStop> {
  double _position = 0;
  final double _maxWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _maxWidth + 60,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Trượt để dừng',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            left: _position,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _position += details.delta.dx;
                  if (_position < 0) _position = 0;
                  if (_position > _maxWidth) _position = _maxWidth;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_position > _maxWidth * 0.8) {
                  widget.onStop();
                }
                setState(() {
                  _position = 0;
                });
              },
              child: Container(
                width: 52,
                height: 52,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Color(0xFF0E0E12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TimeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
