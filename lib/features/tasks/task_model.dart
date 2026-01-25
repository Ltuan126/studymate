import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final Color color;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.start,
    required this.end,
    required this.color,
  });
}
