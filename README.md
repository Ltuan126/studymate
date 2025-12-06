# StudyMate

StudyMate là ứng dụng hỗ trợ sinh viên quản lý môn học, bài tập và deadline hằng ngày, giúp tối ưu hoá việc học và cải thiện hiệu suất cá nhân.

---

## Chức năng chính

- Đăng ký / đăng nhập bằng Firebase Authentication
- Thêm, sửa, xóa môn học
- Thêm, sửa, xóa bài tập theo từng môn
- Đánh dấu bài tập đã hoàn thành
- Xem danh sách bài tập theo ngày, tuần hoặc theo lịch
- Gửi thông báo nhắc deadline
- Thống kê số lượng bài tập đã hoàn thành

---

## Công nghệ sử dụng

- Flutter
- Firebase Authentication
- Cloud Firestore
- flutter_local_notifications
- table_calendar
- fl_chart

---

## Các màn hình chính

- Splash / Onboarding
- Login / Register
- Home
- Subject List / Add Subject
- Task Detail / Add Task
- Calendar
- Statistics
- Settings

---

## Cấu trúc thư mục

```
lib/
├── core/                # hằng số, theme, utils
├── features/
│   ├── auth/            # đăng nhập, đăng ký
│   ├── subjects/        # quản lý môn học
│   ├── tasks/           # quản lý bài tập
│   ├── calendar/        # xem lịch
│   └── statistics/      # biểu đồ thống kê
├── services/
│   ├── firestore/       # xử lý CRUD Firestore
│   ├── notification/    # gửi thông báo
│   └── user/            # quản lý thông tin user
├── widgets/             # widget dùng chung
└── main.dart
```

---

## Cách chạy dự án

1. Clone repository:
```
git clone https://github.com/your-username/studymate.git
```

2. Cài đặt package:
```
flutter pub get
```

3. Cấu hình Firebase:
- Thêm google-services.json (Android)
- Thêm GoogleService-Info.plist (iOS)

4. Chạy ứng dụng:
```
flutter run
```

---

## Định hướng phát triển thêm

- Thêm mục tiêu học tập (Study Goals)
- Thêm chế độ Dark / Light
- Gợi ý lịch học thông minh
- Đồng bộ nhiều thiết bị tốt hơn
