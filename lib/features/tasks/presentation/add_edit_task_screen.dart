import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../subjects/state/subject_controller.dart';
import '../state/task_controller.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = SubjectController();
  final _taskCtrl = TaskController();

  String? _selectedSubjectId;
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4D47E5)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4D47E5)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();

    if (title.isEmpty) {
      _showMsg('Vui lòng nhập tên bài tập');
      return;
    }
    if (_selectedDate == null) {
      _showMsg('Vui lòng chọn ngày');
      return;
    }

    setState(() => _isLoading = true);

    try {
      DateTime? startDateTime;
      if (_startTime != null) {
        startDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }

      DateTime? endDateTime;
      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }

      await _taskCtrl.add(
        title,
        dueDate: _selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        subjectId: _selectedSubjectId,
      );

      if (!mounted) return;
      _showMsg('Đã thêm bài tập thành công');
      Navigator.of(context).pop();
    } catch (e) {
      _showMsg('Lỗi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFDF6FB);
    const primaryColor = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // The "Bottom Sheet" looking card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(
                  0xFFE8E5F7,
                ), // Slightly darker pink/grey for the card background like Figma
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Handle line
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Thêm bài tập mới',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title Input
                    _buildField(
                      hint: 'Tên bài tập',
                      child: TextField(
                        controller: _titleCtrl,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          hintText: 'Tên bài tập',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subject Dropdown
                    _buildField(
                      hint: 'Chọn môn học',
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            _subjectCtrl.getSubjects() as Stream<QuerySnapshot>,
                        builder: (context, snapshot) {
                          final subjects = snapshot.data?.docs ?? [];
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Center(
                                child: Text(
                                  'Chọn môn học',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              value: _selectedSubjectId,
                              items: subjects.map((doc) {
                                return DropdownMenuItem<String>(
                                  value: doc.id,
                                  child: Center(
                                    child: Text(
                                      doc['name'] ?? '',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedSubjectId = val),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    GestureDetector(
                      onTap: _pickDate,
                      child: _buildField(
                        hint: 'Chọn ngày',
                        child: Center(
                          child: Text(
                            _selectedDate != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_selectedDate!)
                                : 'Chọn ngày',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              color: _selectedDate != null
                                  ? Colors.black
                                  : Colors.black26,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Start/End Time Row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(true),
                            child: _buildField(
                              hint: 'Bắt đầu',
                              child: Center(
                                child: Text(
                                  _startTime != null
                                      ? _startTime!.format(context)
                                      : 'Bắt đầu',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    color: _startTime != null
                                        ? Colors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(false),
                            child: _buildField(
                              hint: 'Kết thúc',
                              child: Center(
                                child: Text(
                                  _endTime != null
                                      ? _endTime!.format(context)
                                      : 'Kết thúc',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    color: _endTime != null
                                        ? Colors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Lưu bài tập',
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required Widget child, required String hint}) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0DAF2).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
