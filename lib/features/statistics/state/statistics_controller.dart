class StatisticsController {
  int countTotal(List tasks) {
    return tasks.length;
  }

  int countDone(List tasks) {
    try {
      return tasks.where((task) {
        final map = task as Map<String, dynamic>?;
        return map?['isDone'] == true;
      }).length;
    } catch (e) {
      return 0;
    }
  }

  int getCompletionPercent(List tasks) {
    if (tasks.isEmpty) return 0;
    final done = countDone(tasks);
    return ((done / tasks.length) * 100).toInt();
  }
}
