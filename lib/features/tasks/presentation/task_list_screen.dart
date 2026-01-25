import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state/task_controller.dart';
import 'widgets/task_item.dart';
import 'add_edit_task_screen.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskCtrl = TaskController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Bài tập',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4D47E5),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _taskCtrl.getTasks() as Stream<QuerySnapshot>,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có bài tập nào',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Không tên';
              final isDone = data['isDone'] ?? false;
              final dueDate = data['dueDate'] != null
                  ? (data['dueDate'] as Timestamp).toDate()
                  : null;

              String timeStr = 'Không có deadline';
              if (dueDate != null) {
                timeStr = DateFormat('dd/MM/yyyy HH:mm').format(dueDate);
              }

              return TaskItem(
                title: title,
                subject: 'Bài tập', // Có thể cải thiện hiển thị môn học sau
                time: timeStr,
                isDone: isDone,
                onToggle: (val) {
                  _taskCtrl.toggle(doc.id, val ?? false);
                },
              );
            },
          );
        },
      ),
    );
  }
}
