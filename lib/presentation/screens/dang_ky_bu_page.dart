import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/schedule_service.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';

final ScheduleService scheduleService = ScheduleService();

class DangKyBuPage extends StatefulWidget {
  final ScheduleEntry schedule;
  final UserAccount user;

  const DangKyBuPage({super.key, required this.schedule, required this.user});

  @override
  State<DangKyBuPage> createState() => _DangKyBuPageState();
}

class _DangKyBuPageState extends State<DangKyBuPage> {
  late Course _course;
  late Future<List<ScheduleEntry>> _allSchedulesFuture;

  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  List<int>? _selectedPeriods;
  String? _selectedRoomId;

  String _getVietnameseDayOfWeek(DateTime date) {
    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ Nhật'];
    return days[date.weekday - 1];
  }

  List<List<int>> _availablePeriodOptions = [];
  final List<String> _allRoomOptions = [
    '305-A2',
    '307-A2',
    '301-B5',
    '404-A9'
  ];
  List<String> _availableRoomOptions = [];

  bool _isFindingSuggestion = false;

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu lịch học một lần duy nhất
    _allSchedulesFuture = scheduleService.getAllSchedules();

    // Tìm thông tin học phần tương ứng
    try {
      _course = staticCourses.firstWhere((c) => c.id == widget.schedule.courseId);
    } catch (e) {
      // Fallback nếu không tìm thấy
      _course = Course(
        id: 'error',
        courseCode: 'N/A',
        subjectName: 'Không tìm thấy HP',
        className: 'N/A',
        instructorId: '',
        semesterId: '',
        courseType: '',
        totalPeriods: 0,
        credits: 0,
        studentCount: 0,
        numberOfPeriods: widget.schedule.numberOfPeriods,
      );
    }

    if (widget.schedule.makeupDate != null) {
      _selectedDate = widget.schedule.makeupDate;
      _selectedPeriods = widget.schedule.makeupPeriods;
      _selectedRoomId = widget.schedule.makeupRoomId;
      // Việc lọc sẽ được thực hiện trong FutureBuilder sau khi có dữ liệu
    }
  }

  // --- SỬA LẠI CÁC HÀM LOGIC ĐỂ NHẬN `allSchedules` ---

  void _filterAvailablePeriods(List<ScheduleEntry> allSchedules) {
    if (_selectedDate == null) {
      setState(() {
        _availablePeriodOptions = [];
        _selectedPeriods = null;
        _filterAvailableRooms(allSchedules);
      });
      return;
    }

    final occupiedPeriodsOnSelectedDate = allSchedules
        .where((s) =>
    s.courseId.startsWith('course_') && // Lọc theo gv sau này
        s.date.year == _selectedDate!.year &&
        s.date.month == _selectedDate!.month &&
        s.date.day == _selectedDate!.day)
        .expand((s) => s.periods)
        .toSet();

    final allPossiblePeriodOptions = _generatePossiblePeriods();

    setState(() {
      final currentSelection = _selectedPeriods;

      _availablePeriodOptions = allPossiblePeriodOptions.where((option) {
        // Luôn giữ lại lựa chọn hiện tại (nếu có) trong danh sách
        if (currentSelection != null &&
            const ListEquality().equals(option, currentSelection)) {
          return true;
        }
        return !option.any(
              (period) => occupiedPeriodsOnSelectedDate.contains(period),
        );
      }).toList();

      if (_selectedPeriods != null &&
          !_availablePeriodOptions
              .any((p) => const ListEquality().equals(p, _selectedPeriods))) {
        _selectedPeriods = null;
      }
      _filterAvailableRooms(allSchedules);
    });
  }

  void _filterAvailableRooms(List<ScheduleEntry> allSchedules) {
    if (_selectedDate == null || _selectedPeriods == null) {
      setState(() {
        _availableRoomOptions = [];
        _selectedRoomId = null;
      });
      return;
    }

    final occupiedRooms = allSchedules
        .where((s) =>
    s.date.year == _selectedDate!.year &&
        s.date.month == _selectedDate!.month &&
        s.date.day == _selectedDate!.day &&
        s.periods.any((p) => _selectedPeriods!.contains(p)))
        .map((s) => s.roomId)
        .toSet();

    setState(() {
      final currentSelection = _selectedRoomId;
      _availableRoomOptions = _allRoomOptions.where((room) {
        if (currentSelection != null && room == currentSelection) {
          return true;
        }
        return !occupiedRooms.contains(room);
      }).toList();

      if (_selectedRoomId != null &&
          !_availableRoomOptions.contains(_selectedRoomId)) {
        _selectedRoomId = null;
      }
    });
  }

  Future<void> _selectDate(
      BuildContext context, List<ScheduleEntry> allSchedules) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterAvailablePeriods(allSchedules);
      });
    }
  }

  Future<void> _findAndSetSuggestion(List<ScheduleEntry> allSchedules) async {
    setState(() => _isFindingSuggestion = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final allPossiblePeriodOptions = _generatePossiblePeriods();

    for (int i = 0; i < 30; i++) {
      DateTime currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: i));
      if (currentDate.weekday == DateTime.sunday) continue;

      final occupiedPeriodsOnDate = allSchedules
          .where((s) =>
      s.courseId.startsWith('course_') &&
          s.date.year == currentDate.year &&
          s.date.month == currentDate.month &&
          s.date.day == currentDate.day)
          .expand((s) => s.periods)
          .toSet();

      final availablePeriodsForDay = allPossiblePeriodOptions
          .where((option) => !option.any((p) => occupiedPeriodsOnDate.contains(p)))
          .toList();

      if (availablePeriodsForDay.isEmpty) continue;

      for (final periodOption in availablePeriodsForDay) {
        final occupiedRooms = allSchedules
            .where((s) =>
        s.date.year == currentDate.year &&
            s.date.month == currentDate.month &&
            s.date.day == currentDate.day &&
            s.periods.any((p) => periodOption.contains(p)))
            .map((s) => s.roomId)
            .toSet();

        final availableRoomForPeriod =
        _allRoomOptions.where((room) => !occupiedRooms.contains(room)).toList();

        if (availableRoomForPeriod.isNotEmpty) {
          setState(() {
            _selectedDate = currentDate;
            _selectedPeriods = periodOption;
            _selectedRoomId = availableRoomForPeriod.first;
            _filterAvailablePeriods(allSchedules);
            _isFindingSuggestion = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Đã tìm thấy lịch trống gần nhất!'),
              backgroundColor: Colors.blue));
          return;
        }
      }
    }

    setState(() => _isFindingSuggestion = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Không tìm thấy lịch dạy bù nào còn trống trong 30 ngày tới.'),
      backgroundColor: Colors.orange,
    ));
  }

  void _submitMakeupRequest(List<ScheduleEntry> allSchedules) {
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

    final index = allSchedules.indexWhere((s) => s.id == widget.schedule.id);
    if (index != -1) {
      allSchedules[index].makeupDate = _selectedDate;
      allSchedules[index].makeupPeriods = _selectedPeriods;
      allSchedules[index].makeupRoomId = _selectedRoomId;
      allSchedules[index].makeupStatus = 'pending_makeup';
      allSchedules[index].status = 'missed';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gửi yêu cầu dạy bù thành công.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  List<List<int>> _generatePossiblePeriods() {
    final int requiredPeriods = _course.numberOfPeriods;
    const int maxPeriod = 16;
    List<List<int>> possiblePeriods = [];
    for (int i = 1; i <= maxPeriod - requiredPeriods + 1; i++) {
      List<int> periodBlock = List.generate(requiredPeriods, (j) => i + j);
      possiblePeriods.add(periodBlock);
    }
    return possiblePeriods;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPending = widget.schedule.makeupStatus == 'pending_makeup';
    final String pageTitle = isPending ? 'Chi tiết đơn dạy bù' : 'Đăng ký dạy bù';
    final String buttonLabel = isPending ? 'Cập nhật đơn' : 'Gửi yêu cầu';

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      // SỬ DỤNG FUTUREBUILDER ĐỂ LẤY DỮ LIỆU
      body: FutureBuilder<List<ScheduleEntry>>(
        future: _allSchedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Không có dữ liệu lịch học."));
          }

          final allSchedules = snapshot.data!;

          // Khởi tạo bộ lọc nếu là lần đầu xem đơn đã có
          if (isPending && _availablePeriodOptions.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if(mounted) {
                _filterAvailablePeriods(allSchedules);
              }
            });
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SỬA LỖI: Lấy tên từ _course ---
                    Text(
                      'Học phần: ${_course.subjectName} (${_course.className})',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                              : () => _findAndSetSuggestion(allSchedules),
                          icon: _isFindingSuggestion
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                            CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.auto_awesome,
                              size: 20, color: Colors.orange),
                          label: Text(
                            'Gợi ý',
                            style: TextStyle(
                              color: _isFindingSuggestion
                                  ? Colors.grey
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Truyền allSchedules vào các widget con
                    _buildDatePicker(allSchedules),
                    const SizedBox(height: 24),
                    _buildAnimatedPeriodSelector(allSchedules),
                    const SizedBox(height: 24),
                    _buildAnimatedRoomSelector(allSchedules),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _submitMakeupRequest(allSchedules),
                        icon: const Icon(Icons.send),
                        label: Text(buttonLabel),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- SỬA LẠI CÁC WIDGET BUILD ĐỂ NHẬN `allSchedules` ---

  Widget _buildDatePicker(List<ScheduleEntry> allSchedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ngày học:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, allSchedules),
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Chọn ngày'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedPeriodSelector(List<ScheduleEntry> allSchedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ca học:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        if (_selectedDate == null)
          const Text('Vui lòng chọn ngày trước', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
        if (_selectedDate != null && _availablePeriodOptions.isEmpty)
          const Text('Không có ca học nào phù hợp còn trống trong ngày này.', style: TextStyle(color: Colors.red)),
        if (_selectedDate != null && _availablePeriodOptions.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _availablePeriodOptions.map((periodOption) {
                final isSelected = _selectedPeriods != null &&
                    const ListEquality().equals(_selectedPeriods, periodOption);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPeriods = periodOption;
                        _filterAvailableRooms(allSchedules);
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                      ),
                      child: Text('Tiết ${periodOption.join('-')}'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedRoomSelector(List<ScheduleEntry> allSchedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phòng học:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        if (_selectedPeriods == null)
          const Text('Vui lòng chọn ca học trước', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
        if (_selectedPeriods != null && _availableRoomOptions.isEmpty)
          const Text('Không có phòng học nào còn trống trong ca này.', style: TextStyle(color: Colors.red)),
        if (_selectedPeriods != null && _availableRoomOptions.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _availableRoomOptions.map((room) {
                final isSelected = _selectedRoomId == room;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRoomId = room;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                      ),
                      child: Text(room),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        String? label,
        Widget? child,
      }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, size: 25, color: textTheme.bodySmall?.color),
          ),
          const SizedBox(width: 12),
          if (label != null)
            Text(label, style: textTheme.bodyMedium?.copyWith(fontSize: 20)),
          if (child != null)
            Expanded(
              child: DefaultTextStyle(
                style: textTheme.bodyMedium!.copyWith(fontSize: 20),
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
        Icon(icon, size: 25, color: Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal)),
      ],
    );
  }
}
