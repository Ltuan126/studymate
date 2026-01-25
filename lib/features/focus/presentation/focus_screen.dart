import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/focus_timer.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = FocusTimer.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),
      body: Center(
        child: AnimatedBuilder(
          animation: timer,
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ===== CIRCLE =====
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(260, 260),
                        painter: CirclePainter(timer.progress),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timer.formattedTime,
                            style: const TextStyle(
                              fontSize: 44,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            timer.isRunning
                                ? 'đang tập trung'
                                : 'sẵn sàng',
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// ===== ADD TIME =====
                if (!timer.isRunning)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      timeBtn('-5', () => timer.addMinutes(-5)),
                      timeBtn('+5', () => timer.addMinutes(5)),
                      timeBtn('+25', () => timer.addMinutes(25)),
                    ],
                  ),

                const SizedBox(height: 30),

                /// ===== CONTROL BUTTON =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 52,
                      color: Colors.white,
                      icon: Icon(
                        timer.isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: timer.isRunning
                          ? timer.pause
                          : timer.start,
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      iconSize: 42,
                      color: Colors.white54,
                      icon: const Icon(Icons.stop),
                      onPressed: timer.reset,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget timeBtn(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white10,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

/// ===== PAINTER =====
class CirclePainter extends CustomPainter {
  final double progress;
  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final bg = Paint()
      ..color = Colors.white12
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final fg = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF6C63FF),
          Color(0xFF4FACFE),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bg);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
