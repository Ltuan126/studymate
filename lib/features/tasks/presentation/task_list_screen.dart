import 'package:flutter/material.dart';
import 'widgets/task_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // TODO: Navigate to AddEditTaskScreen
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            TaskItem(
              title: 'Lập trình web',
              subject: 'CNTT',
              time: '08:00 - 09:30',
            ),
            TaskItem(
              title: 'Cấu trúc dữ liệu',
              subject: 'CNTT',
              time: '09:40 - 11:10',
            ),
            TaskItem(
              title: 'Cơ sở dữ liệu',
              subject: 'CNTT',
              time: '11:20 - 12:50',
              isDone: true,
            ),
          ],
        ),
      ),
    );
  }
}
