import 'package:flutter/material.dart';

class AddEditSubjectScreen extends StatelessWidget {
  const AddEditSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm môn học'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tên môn học',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
               
              },
              child: const Text('Lưu môn học'),
            ),
          ],
        ),
      ),
    );
  }
}
