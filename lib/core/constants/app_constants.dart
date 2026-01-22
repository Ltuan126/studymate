class AppConstants {
  static const appName = 'StudyMate';
  static const appVersion = '1.0.0';
  static const timeoutDuration = Duration(seconds: 30);
}

class FirestoreKeys {
  // Collections
  static const String users = 'users';
  static const String subjects = 'subjects';
  static const String tasks = 'tasks';

  // Task Fields
  static const String taskTitle = 'title';
  static const String taskIsDone = 'isDone';
  static const String taskCreatedAt = 'createdAt';
  static const String taskUpdatedAt = 'updatedAt';
  static const String taskDueDate = 'dueDate';
  static const String taskSubjectId = 'subjectId';
  static const String taskDescription = 'description';

  // Subject Fields
  static const String subjectName = 'name';
  static const String subjectCreatedAt = 'createdAt';
  static const String subjectUpdatedAt = 'updatedAt';
  static const String subjectColor = 'color';
}

class ErrorMessages {
  static const String notLoggedIn = 'Bạn chưa đăng nhập';
  static const String networkError = 'Lỗi kết nối mạng';
  static const String unknownError = 'Lỗi không xác định';
  static const String emptyField = 'Không được để trống';
}
