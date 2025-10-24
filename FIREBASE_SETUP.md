# Hướng dẫn Setup Firebase cho TLU Schedule App

## 1. Cài đặt Firebase Dependencies

Dependencies đã được thêm vào `pubspec.yaml`:
- firebase_core: ^3.6.0
- firebase_auth: ^5.3.1
- cloud_firestore: ^5.4.4
- firebase_storage: ^12.3.2
- firebase_messaging: ^15.1.3
- firebase_analytics: ^11.3.3

## 2. Cấu hình Firebase Project

### Bước 1: Tạo Firebase Project
1. Truy cập [Firebase Console](https://console.firebase.google.com/u/0/project/testtluscheduleapp/overview?pli=1)
2. Project đã được tạo với tên: `testtluscheduleapp`

### Bước 2: Cấu hình Android
1. Tải file `google-services.json` từ Firebase Console
2. Đặt file vào thư mục `android/app/`
3. Cấu hình đã được thêm vào `android/build.gradle.kts` và `android/app/build.gradle.kts`

### Bước 3: Cấu hình iOS (nếu cần)
1. Tải file `GoogleService-Info.plist` từ Firebase Console
2. Đặt file vào thư mục `ios/Runner/`
3. Thêm vào Xcode project

## 3. Cấu hình Firestore

### Security Rules
File `firestore.rules` đã được tạo với các quy tắc bảo mật:
- Phòng đào tạo có quyền truy cập đầy đủ
- Giảng viên chỉ có thể truy cập dữ liệu của mình
- Sinh viên có quyền đọc hạn chế

### Collections Structure
```
/users - Thông tin người dùng (giảng viên, phòng đào tạo)
/students - Thông tin sinh viên
/courses - Thông tin môn học
/semesters - Thông tin học kỳ
/teaching_schedules - Lịch giảng dạy
/attendance_reports - Báo cáo điểm danh
/payment_reports - Báo cáo thanh toán
/notifications - Thông báo
/activity_logs - Nhật ký hoạt động
```

## 4. Sử dụng Firebase Services

### Khởi tạo Firebase
```dart
import 'core/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(MyApp());
}
```

### Authentication Service
```dart
import 'data/services/firebase_auth_service.dart';

final authService = FirebaseAuthService();

// Đăng nhập
final user = await authService.signInWithUsername(
  username: 'dt01',
  password: '123',
);
```

### Training Department Service
```dart
import 'data/services/training_department_service.dart';

final trainingService = TrainingDepartmentService();

// Lấy danh sách giảng viên
final lecturers = await trainingService.getAllLecturers();

// Lấy thống kê
final stats = await trainingService.getDepartmentStatistics();
```

### Data Migration
```dart
import 'data/services/data_migration_service.dart';

final migrationService = DataMigrationService();

// Migrate dữ liệu static sang Firebase
await migrationService.migrateAllStaticData();
```

## 5. Demo Screen

Đã tạo `FirebaseDemoScreen` để test các tính năng:
- Kiểm tra kết nối Firebase
- Migrate dữ liệu từ static data
- Test authentication
- Test các API của phòng đào tạo

## 6. Chạy App

1. Cài đặt dependencies:
```bash
flutter pub get
```

2. Chạy app:
```bash
flutter run
```

3. Truy cập Firebase Demo Screen để test backend

## 7. Các tính năng đã implement

### Phòng đào tạo có thể:
- Quản lý giảng viên (CRUD)
- Quản lý sinh viên (CRUD)
- Quản lý môn học (CRUD)
- Quản lý lịch giảng dạy
- Xem báo cáo điểm danh
- Xem báo cáo thanh toán
- Gửi thông báo cho giảng viên
- Xem thống kê tổng quan
- Xem thống kê hiệu suất giảng viên

### Giảng viên có thể:
- Xem lịch giảng dạy của mình
- Quản lý điểm danh
- Xem thông báo
- Xem nhật ký hoạt động

## 8. Lưu ý quan trọng

1. **Bảo mật**: Đảm bảo file `google-services.json` không được commit lên Git
2. **Testing**: Sử dụng Firebase Demo Screen để test các tính năng
3. **Migration**: Chạy migration một lần để chuyển dữ liệu static sang Firebase
4. **Rules**: Cập nhật Firestore rules nếu cần thay đổi quyền truy cập

## 9. Troubleshooting

### Lỗi kết nối Firebase
- Kiểm tra file `google-services.json` có đúng vị trí không
- Kiểm tra package name trong Firebase Console
- Kiểm tra SHA-1 fingerprint cho Android

### Lỗi Firestore Rules
- Kiểm tra rules trong Firebase Console
- Đảm bảo user đã được authenticate
- Kiểm tra quyền truy cập của user

### Lỗi Migration
- Kiểm tra kết nối internet
- Kiểm tra quyền write trong Firestore
- Kiểm tra dữ liệu static có đúng format không

