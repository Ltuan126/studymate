StudyMate

StudyMate là ứng dụng hỗ trợ sinh viên quản lý môn học, bài tập và deadline hằng ngày, giúp tối ưu hoá việc học và cải thiện hiệu suất cá nhân.

Chức năng chính

Đăng ký / đăng nhập bằng Firebase Authentication

Thêm, sửa, xóa môn học

Thêm, sửa, xóa bài tập theo từng môn

Đánh dấu bài tập đã hoàn thành

Xem danh sách bài tập theo ngày, tuần hoặc theo lịch

Gửi thông báo nhắc deadline

Thống kê số lượng bài tập đã hoàn thành

Giao diện đơn giản, dễ sử dụng

Công nghệ sử dụng

Flutter

Firebase Authentication (xác thực người dùng)

Cloud Firestore (lưu trữ dữ liệu theo thời gian thực)

flutter_local_notifications (nhắc deadline)

table_calendar (hiển thị lịch)

fl_chart (thống kê dạng biểu đồ)

Các màn hình chính

Splash / Onboarding

Login / Register

Home (danh sách bài tập hôm nay)

Subject List / Add Subject

Task Detail / Add Task

Calendar (xem deadline theo ngày)

Statistics (biểu đồ tiến độ)

Settings (quản lý tài khoản & cấu hình app)

Cấu trúc thư mục
lib/
├── core/                # hằng số, theme, utils, styles
├── features/
│   ├── auth/            # login, register, firebase auth
│   ├── subjects/        # màn hình + logic môn học
│   ├── tasks/           # màn hình + logic bài tập
│   ├── calendar/        # lịch + filter theo ngày
│   └── statistics/      # biểu đồ, tính toán tiến độ
├── services/
│   ├── firestore/       # CRUD Firestore
│   ├── notification/    # local notification
│   └── user/            # profile service
├── widgets/             # widget dùng chung trong app
└── main.dart
