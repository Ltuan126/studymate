import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _noteController = TextEditingController();

  String _gender = 'Nam';
  DateTime? _birthDate;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data();
    if (data == null) return;

    _nameController.text = data['name'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _jobController.text = data['job'] ?? '';
    _noteController.text = data['note'] ?? '';
    _gender = data['gender'] ?? 'Nam';

    if (data['birthDate'] != null) {
      _birthDate = (data['birthDate'] as Timestamp).toDate();
    }

    setState(() {});
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': _nameController.text.trim(),
      'birthDate': Timestamp.fromDate(_birthDate!),
      'phone': _phoneController.text.trim(),
      'gender': _gender,
      'job': _jobController.text.trim(),
      'note': _noteController.text.trim(),
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final birthText = _birthDate == null
        ? 'Chọn ngày sinh'
        : DateFormat('dd/MM/yyyy').format(_birthDate!);

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// ===== BẮT BUỘC =====
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên *'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Bắt buộc' : null,
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration:
                      const InputDecoration(labelText: 'Ngày sinh *'),
                  child: Text(birthText),
                ),
              ),

              const SizedBox(height: 24),

              /// ===== KHÔNG BẮT BUỘC =====
              TextFormField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                  DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                  DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                ],
                onChanged: (v) => setState(() => _gender = v!),
                decoration:
                    const InputDecoration(labelText: 'Giới tính'),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(
                    labelText: 'Trường / Nghề nghiệp'),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                decoration:
                    const InputDecoration(labelText: 'Ghi chú'),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _save,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
