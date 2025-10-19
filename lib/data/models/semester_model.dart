// 1️⃣ Định nghĩa class Semester
class SemesterModel {
  final String id; // ví dụ: "2025_1" hoặc "2025_2"
  final DateTime startDate;
  final DateTime endDate;

  SemesterModel({
    required this.id,
    required this.startDate,
    required this.endDate,
  });

  @override
  String toString() => id;
}

// 2️⃣ Dữ liệu mẫu
final List<SemesterModel> mockSemesters = [
  SemesterModel(
    id: '2025_1',
    startDate: DateTime(2025, 1, 15),
    endDate: DateTime(2025, 5, 15),
  ),
  SemesterModel(
    id: '2025_2',
    startDate: DateTime(2025, 8, 15),
    endDate: DateTime(2025, 12, 15),
  ),
  SemesterModel(
    id: '2026_1',
    startDate: DateTime(2026, 1, 15),
    endDate: DateTime(2026, 5, 15),
  ),
];

// 3️⃣ Biến state để giữ giá trị selected
SemesterModel? _selectedSemester = mockSemesters.first;
