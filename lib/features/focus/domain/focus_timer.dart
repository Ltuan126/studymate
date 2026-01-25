import 'dart:async';
import 'package:flutter/material.dart';

class FocusTimer extends ChangeNotifier {
  FocusTimer._internal();
  static final FocusTimer instance = FocusTimer._internal();

  Timer? _timer;

  Duration _total = Duration.zero;     // tổng thời gian
  Duration _remaining = Duration.zero; // còn lại
  bool _isRunning = false;

  // ===== GETTERS =====
  Duration get remaining => _remaining;
  Duration get total => _total;
  bool get isRunning => _isRunning;

  /// Tỉ lệ vòng tròn (1.0 -> 0.0)
  double get progress {
    if (_total.inSeconds == 0) return 0;
    return _remaining.inSeconds / _total.inSeconds;
  }

  /// Format hiển thị (mm:ss hoặc hh:mm:ss)
  String get formattedTime {
    final h = _remaining.inHours;
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:$m:$s';
    }
    return '$m:$s';
  }

  // ===== LOGIC =====

  /// Set thời gian ban đầu (phút)
  void setMinutes(int minutes) {
    if (minutes <= 0) return;
    _total = Duration(minutes: minutes);
    _remaining = _total;
    notifyListeners();
  }

  /// Thêm / bớt phút (KHÔNG GIỚI HẠN)
  void addMinutes(int minutes) {
    final delta = Duration(minutes: minutes);

    _total += delta;
    _remaining += delta;

    if (_total.isNegative) {
      _total = Duration.zero;
      _remaining = Duration.zero;
    }

    notifyListeners();
  }

  /// Start / Resume
  void start() {
    if (_isRunning || _remaining.inSeconds <= 0) return;

    _isRunning = true;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 1) {
        reset();
      } else {
        _remaining -= const Duration(seconds: 1);
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// Pause
  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  /// Reset về ban đầu
  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _remaining = _total;
    notifyListeners();
  }

  /// Dọn khi app dispose
  void disposeTimer() {
    _timer?.cancel();
  }
}
