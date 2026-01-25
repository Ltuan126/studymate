import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymate/features/tasks/presentation/add_edit_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  DateTime get _startOfDay =>
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  DateTime get _endOfDay => DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    23,
    59,
    59,
  );

  Stream<QuerySnapshot>? _getTasksStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where(
          'dueDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(_startOfDay),
        )
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(_endOfDay))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM, yyyy', 'vi').format(selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            monthTitle.replaceFirst(monthTitle[0], monthTitle[0].toUpperCase()),
            style: GoogleFonts.manrope(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildDaySelector(),
          const SizedBox(height: 40),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    // Use selectedDate to determine the week to show
    final startWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final day = startWeek.add(Duration(days: i));
          final isSelected = DateUtils.isSameDay(day, selectedDate);

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedDate = day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: isSelected
                    ? BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF6C63FF), Color(0xFF4D47E5)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4D47E5,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('EEE', 'vi').format(day),
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd').format(day),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data?.docs ?? [];
        if (tasks.isEmpty) {
          return Center(
            child: Text(
              'Chưa có lịch trình',
              style: GoogleFonts.manrope(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        // Sort tasks by startTime, fallback to dueDate
        final sortedTasks = List<QueryDocumentSnapshot>.from(tasks)
          ..sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final t1 =
                (dataA['startTime'] as Timestamp?) ??
                (dataA['dueDate'] as Timestamp?);
            final t2 =
                (dataB['startTime'] as Timestamp?) ??
                (dataB['dueDate'] as Timestamp?);
            if (t1 == null) return 1;
            if (t2 == null) return -1;
            return t1.compareTo(t2);
          });

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: sortedTasks.length,
          itemBuilder: (_, index) {
            final doc = sortedTasks[index];
            final data = doc.data() as Map<String, dynamic>;
            final startTime = (data['startTime'] as Timestamp?)?.toDate();
            final endTime = (data['endTime'] as Timestamp?)?.toDate();
            final displayTime =
                startTime ?? (data['dueDate'] as Timestamp?)?.toDate();

            // Random-ish color for demo or based on status
            Color barColor = const Color(0xFF4D47E5);
            if (index % 3 == 0) barColor = const Color(0xFFE53935);
            if (index % 3 == 1) barColor = const Color(0xFF8BC34A);

            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time
                  SizedBox(
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        displayTime != null
                            ? DateFormat('HH:mm').format(displayTime)
                            : '--:--',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Task Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] ?? 'N/A',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            startTime != null && endTime != null
                                ? '${DateFormat('H:mm').format(startTime)} - ${DateFormat('H:mm').format(endTime)}'
                                : (displayTime != null
                                      ? DateFormat('H:mm').format(displayTime)
                                      : 'N/A'),
                            style: GoogleFonts.manrope(
                              color: const Color(
                                0xFF4D47E5,
                              ).withValues(alpha: 0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Thick Bottom Bar
                          Container(
                            height: 12,
                            width: 100, // Matching Figma wide bar
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
