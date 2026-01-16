import 'package:flutter/material.dart';

class CalendarController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
