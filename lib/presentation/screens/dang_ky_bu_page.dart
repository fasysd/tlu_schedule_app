import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/mock_data.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';

class DangKyBuPage extends StatefulWidget {
  final ScheduleEntry schedule;
  final UserAccount user;

  const DangKyBuPage({super.key, required this.schedule, required this.user});

  @override
  State<DangKyBuPage> createState() => _DangKyBuPageState();
}

class _DangKyBuPageState extends State<DangKyBuPage> {
  // --- THÊM MỚI: State để quản lý dữ liệu bất đồng bộ ---
  late Future<List<ScheduleEntry>> _schedulesFuture;
  List<ScheduleEntry> _allSchedules = []; // Cache lại danh sách lịch

  late Course _course;

  DateTime? _selectedDate;
  List<int>? _selectedPeriods;
  String? _selectedRoomId;

  List<List<int>> _allPossiblePeriodOptions = [];
  final List<String> _allRoomOptions = ['305-A2', '307-A2', '301-B5', '404-A9'];

  List<List<int>> _availablePeriodOptions = [];
  List<String> _availableRoomOptions = [];

  bool _isFindingSuggestion = false;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = scheduleService.getAllSchedules();
    _course = mockCourses.firstWhere((c) => c.id == widget.schedule.courseId);
    _generatePossiblePeriods();

    if (widget.schedule.makeupDate != null) {
      _selectedDate = widget.schedule.makeupDate;
      _selectedPeriods = widget.schedule.makeupPeriods;
      _selectedRoomId = widget.schedule.makeupRoomId;
    }
  }

  void _generatePossiblePeriods() {
    final int requiredPeriods = widget.schedule.numberOfPeriods;
    const int maxPeriod = 16;
    List<List<int>> possiblePeriods = [];
    for (int i = 1; i <= maxPeriod - requiredPeriods + 1; i++) {
      List<int> periodBlock = List.generate(requiredPeriods, (j) => i + j);
      possiblePeriods.add(periodBlock);
    }
    _allPossiblePeriodOptions = possiblePeriods;
  }

  // Sửa hàm này để dùng _allSchedules thay vì mockSchedules
  void _filterAvailablePeriods() {
    if (_selectedDate == null) {
      setState(() {
        _availablePeriodOptions = [];
        _selectedPeriods = null;
      });
      _filterAvailableRooms();
      return;
    }

    final instructorCourseIds = mockCourses
        .where((c) => c.instructorId == widget.user.id)
        .map((c) => c.id)
        .toSet();

    final occupiedPeriodsOnSelectedDate = _allSchedules
        .where(
          (s) =>
              instructorCourseIds.contains(s.courseId) &&
              s.date.year == _selectedDate!.year &&
              s.date.month == _selectedDate!.month &&
              s.date.day == _selectedDate!.day,
        )
        .expand((s) => s.periods)
        .toSet();

    setState(() {
      _availablePeriodOptions = _allPossiblePeriodOptions.where((option) {
        return !option.any(
          (period) => occupiedPeriodsOnSelectedDate.contains(period),
        );
      }).toList();

      if (_selectedPeriods != null &&
          !_availablePeriodOptions.any(
            (p) => p.join() == _selectedPeriods!.join(),
          )) {
        _selectedPeriods = null;
      }
    });
    _filterAvailableRooms();
  }

  // Sửa hàm này để dùng _allSchedules
  void _filterAvailableRooms() {
    if (_selectedDate == null || _selectedPeriods == null) {
      setState(() {
        _availableRoomOptions = [];
        _selectedRoomId = null;
      });
      return;
    }

    final occupiedRooms = _allSchedules
        .where(
          (s) =>
              s.date.year == _selectedDate!.year &&
              s.date.month == _selectedDate!.month &&
              s.date.day == _selectedDate!.day &&
              s.periods.any((p) => _selectedPeriods!.contains(p)),
        )
        .map((s) => s.roomId)
        .toSet();

    setState(() {
      _availableRoomOptions = _allRoomOptions
          .where((room) => !occupiedRooms.contains(room))
          .toList();
      if (_selectedRoomId != null &&
          !_availableRoomOptions.contains(_selectedRoomId)) {
        _selectedRoomId = null;
      }
    });
  }

  // Sửa hàm này để dùng _allSchedules
  Future<void> _findAndSetSuggestion() async {
    setState(() {
      _isFindingSuggestion = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    DateTime checkDate = DateTime.now().add(const Duration(days: 1));

    for (int i = 0; i < 30; i++) {
      DateTime currentDate = checkDate.add(Duration(days: i));
      if (currentDate.weekday == DateTime.sunday) continue;

      final instructorCourseIds = mockCourses
          .where((c) => c.instructorId == widget.user.id)
          .map((c) => c.id)
          .toSet();

      final occupiedPeriodsOnDate = _allSchedules
          .where(
            (s) =>
                instructorCourseIds.contains(s.courseId) &&
                s.date.year == currentDate.year &&
                s.date.month == currentDate.month &&
                s.date.day == currentDate.day,
          )
          .expand((s) => s.periods)
          .toSet();

      final availablePeriodsForDay = _allPossiblePeriodOptions.where((option) {
        return !option.any((p) => occupiedPeriodsOnDate.contains(p));
      }).toList();

      if (availablePeriodsForDay.isEmpty) continue;

      for (final periodOption in availablePeriodsForDay) {
        final occupiedRooms = _allSchedules
            .where(
              (s) =>
                  s.date.year == currentDate.year &&
                  s.date.month == currentDate.month &&
                  s.date.day == currentDate.day &&
                  s.periods.any((p) => periodOption.contains(p)),
            )
            .map((s) => s.roomId)
            .toSet();

        final availableRoomForPeriod = _allRoomOptions
            .where((room) => !occupiedRooms.contains(room))
            .toList();

        if (availableRoomForPeriod.isNotEmpty) {
          setState(() {
            _selectedDate = currentDate;
            _selectedPeriods = periodOption;
            _selectedRoomId = availableRoomForPeriod.first;
            _filterAvailablePeriods();
            _filterAvailableRooms();
            _isFindingSuggestion = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã tìm thấy lịch trống gần nhất!'),
              backgroundColor: Colors.blue,
            ),
          );
          return;
        }
      }
    }
    setState(() {
      _isFindingSuggestion = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Không tìm thấy lịch dạy bù nào còn trống trong 30 ngày tới.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Hàm gửi yêu cầu, cần được cập nhật để gọi service
  void _submitMakeupRequest() {
    if (_selectedDate == null ||
        _selectedPeriods == null ||
        _selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn đầy đủ thông tin.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // NOTE: Đây là nơi bạn sẽ gọi service để cập nhật dữ liệu trên server (Firebase)
    // Tạm thời, chúng ta chỉ cập nhật trên widget.schedule để UI trang trước đó có thể cập nhật
    setState(() {
      widget.schedule.makeupDate = _selectedDate;
      widget.schedule.makeupPeriods = _selectedPeriods;
      widget.schedule.makeupRoomId = _selectedRoomId;
      widget.schedule.makeupStatus = 'pending_makeup';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gửi yêu cầu dạy bù thành công.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  // --- Các hàm build giữ nguyên, chỉ bọc phần body bằng FutureBuilder ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterAvailablePeriods();
      });
    }
  }

  String _getVietnameseDayOfWeek(DateTime date) {
    const days = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ Nhật',
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.schedule.makeupStatus == 'pending_makeup'
              ? 'Chi tiết đơn dạy bù'
              : 'Đăng ký dạy bù',
        ),
      ),
      // Bọc body bằng FutureBuilder
      body: FutureBuilder<List<ScheduleEntry>>(
        future: _schedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Lỗi tải dữ liệu lịch: ${snapshot.error}"),
            );
          }

          if (snapshot.hasData && _allSchedules.isEmpty) {
            _allSchedules = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                if (_selectedDate != null) {
                  _filterAvailablePeriods();
                  _filterAvailableRooms();
                }
              }
            });
          }
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    final bool isPending = widget.schedule.makeupStatus == 'pending_makeup';
    final String buttonLabel = isPending ? 'Cập nhật đơn' : 'Gửi yêu cầu';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Học phần: ${_course.subjectName} (${_course.className})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.access_time,
              label: 'Thời gian:',
              child: Text(
                ' ${DateFormat('HH:mm').format(widget.schedule.startTime)} - ${DateFormat('HH:mm').format(widget.schedule.endTime)}',
                style: const TextStyle(color: Colors.red, fontSize: 21),
              ),
            ),
            _buildInfoRow(
              context,
              icon: Icons.location_on_outlined,
              label: 'Phòng học:',
              child: Text(' ${widget.schedule.roomId}'),
            ),
            _buildInfoRow(
              context,
              icon: Icons.calendar_today_outlined,
              child: Text(
                'Tiết ${widget.schedule.periods.join('-')}, ${_getVietnameseDayOfWeek(widget.schedule.date)}, Ngày ${DateFormat('dd/MM/yyyy').format(widget.schedule.date)}',
              ),
            ),
            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: 'Giảng viên:',
              child: Text(
                ' ${widget.user.fullName} - ${widget.user.id.toUpperCase()}',
              ),
            ),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle(
                  context,
                  'Thông tin dạy bù',
                  Icons.edit_calendar,
                ),
                TextButton.icon(
                  onPressed: _isFindingSuggestion
                      ? null
                      : _findAndSetSuggestion,
                  icon: _isFindingSuggestion
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.auto_awesome,
                          size: 20,
                          color: Colors.orange,
                        ),
                  label: Text(
                    'Gợi ý',
                    style: TextStyle(
                      color: _isFindingSuggestion ? Colors.grey : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(),
            const SizedBox(height: 16),
            _buildPeriodPicker(),
            const SizedBox(height: 16),
            _buildRoomPicker(),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submitMakeupRequest,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    String? label,
    Widget? child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              icon,
              size: 25,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(width: 12),
          if (label != null)
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 20),
            ),
          if (child != null)
            Expanded(
              child: DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 20),
                child: child,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Ngày dạy bù',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'Chọn ngày'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodPicker() {
    // --- SỬA LỖI ---
    // Kiểm tra xem giá trị đã chọn có thực sự tồn tại trong danh sách các lựa chọn hay không.
    final bool isValueInItems =
        _selectedPeriods != null &&
        _availablePeriodOptions.any(
          (p) => p.join(',') == _selectedPeriods!.join(','),
        );

    return DropdownButtonFormField<List<int>>(
      value: isValueInItems ? _selectedPeriods : null,
      items: _availablePeriodOptions.map<DropdownMenuItem<List<int>>>((
        List<int> value,
      ) {
        return DropdownMenuItem<List<int>>(
          value: value,
          child: Text(
            'Tiết ${value.join('-')}',
            style: const TextStyle(
              fontSize: 20,
            ), // <-- Sửa lại size chữ cho nhất quán
          ),
        );
      }).toList(),
      onChanged: _selectedDate == null
          ? null
          : (List<int>? newValue) {
              setState(() {
                _selectedPeriods = newValue;
                _filterAvailableRooms();
              });
            },
      decoration: InputDecoration(
        labelText: 'Tiết dạy',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabled: _selectedDate != null,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildRoomPicker() {
    // Kiểm tra xem giá trị hiện tại có nằm trong danh sách lựa chọn không
    final bool isValueInItems =
        _selectedRoomId != null &&
            _availableRoomOptions.contains(_selectedRoomId);

    return DropdownButtonFormField<String>(
      value: isValueInItems ? _selectedRoomId : null,
      items: _availableRoomOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 20)),
        );
      }).toList(),
      onChanged: _selectedPeriods == null
          ? null
          : (String? newValue) {
        setState(() {
          _selectedRoomId = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Phòng học',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabled: _selectedPeriods != null,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
