import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';

import 'lecturer_model.dart';
import 'course_model.dart';

class TeachingRequestFilterModel {
  final List<LecturerModel> lecturers;
  final List<CourseModel> courses;
  final bool includeDonXinNghi;
  final bool includeDonDayBu;
  final bool includeDaXacNhan;
  final bool includeTuChoi;
  final bool includeChuaXacNhan;

  TeachingRequestFilterModel({
    required this.lecturers,
    required this.courses,
    required this.includeDonXinNghi,
    required this.includeDonDayBu,
    required this.includeDaXacNhan,
    required this.includeTuChoi,
    required this.includeChuaXacNhan,
  });

  factory TeachingRequestFilterModel.defaultFilter() =>
      TeachingRequestFilterModel(
        lecturers: [],
        courses: [],
        includeDonXinNghi: true,
        includeDonDayBu: true,
        includeDaXacNhan: false,
        includeTuChoi: false,
        includeChuaXacNhan: true,
      );

  TeachingRequestFilterModel copyWith({
    List<LecturerModel>? lecturers,
    List<CourseModel>? courses,
    bool? includeDaXacNhan,
    bool? includeTuChoi,
    bool? includeChuaXacNhan,
    bool? includeDonDayBu,
    bool? includeDonXinNghi,
  }) {
    return TeachingRequestFilterModel(
      lecturers: lecturers != null
          ? List<LecturerModel>.from(lecturers)
          : List<LecturerModel>.from(this.lecturers),
      courses: courses != null
          ? List<CourseModel>.from(courses)
          : List<CourseModel>.from(this.courses),
      includeDaXacNhan: includeDaXacNhan ?? this.includeDaXacNhan,
      includeTuChoi: includeTuChoi ?? this.includeTuChoi,
      includeChuaXacNhan: includeChuaXacNhan ?? this.includeChuaXacNhan,
      includeDonDayBu: includeDonDayBu ?? this.includeDonDayBu,
      includeDonXinNghi: includeDonXinNghi ?? this.includeDonXinNghi,
    );
  }

  bool matches(TeachingRequestModel request) {
    final matchLecturer =
        lecturers.isEmpty || lecturers.any((l) => l.id == request.idGiangVien);
    final matchCourse =
        courses.isEmpty || courses.any((c) => c.maHocPhan == request.maHocPhan);
    final matchStatus =
        (includeDaXacNhan && request.trangThai == "Đã xác nhận") ||
        (includeTuChoi && request.trangThai == "Từ chối") ||
        (includeChuaXacNhan && request.trangThai == "Chưa xác nhận");
    final matchLoaiDon =
        (includeDonXinNghi && request.loaiDon == "Đơn xin nghỉ dạy") ||
        (includeDonDayBu && request.loaiDon == "Đơn xin dạy bù");
    return matchLecturer && matchCourse && matchStatus && matchLoaiDon;
  }
}
