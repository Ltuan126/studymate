class StatisticsController {
  int countTotal(Iterable tasks) {
    return tasks.length;
  }

  int countDone(Iterable tasks) {
    return tasks.where((t) => t['isDone'] == true).length;
  }
}
