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
  DateTime? _selectedDate;
  List<int>? _selectedPeriods;
  String? _selectedRoomId;

  List<List<int>> _allPossiblePeriodOptions = [];
  final List<String> _allRoomOptions = ['305-A2', '307-A2', '301-B5', '404-A9'];

  List<List<int>> _availablePeriodOptions = [];
  List<String> _availableRoomOptions = [];

  bool _isFindingSuggestion = false; // State để hiển thị loading

  @override
  void initState() {
    super.initState();
    _generatePossiblePeriods();

    if (widget.schedule.makeupDate != null) {
      _selectedDate = widget.schedule.makeupDate;
      _selectedPeriods = widget.schedule.makeupPeriods;
      _selectedRoomId = widget.schedule.makeupRoomId;
      _filterAvailablePeriods();
      _filterAvailableRooms();
    } else {
      _availablePeriodOptions = [];
      _availableRoomOptions = [];
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

  void _filterAvailablePeriods() {
    if (_selectedDate == null) {
      setState(() {
        _availablePeriodOptions = [];
        _selectedPeriods = null;
      });
      _filterAvailableRooms();
      return;
    }

    final occupiedPeriodsOnSelectedDate = mockSchedules
        .where(
          (s) =>
              s.instructorId == widget.user.id &&
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

  void _filterAvailableRooms() {
    if (_selectedDate == null || _selectedPeriods == null) {
      setState(() {
        _availableRoomOptions = [];
        _selectedRoomId = null;
      });
      return;
    }

    final occupiedRooms = mockSchedules
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

  /// Tự động tìm và điền lịch trống gần nhất
  Future<void> _findAndSetSuggestion() async {
    setState(() {
      _isFindingSuggestion = true;
    });

    await Future.delayed(const Duration(milliseconds: 300)); // Giả lập loading

    DateTime checkDate = DateTime.now().add(const Duration(days: 1));

    for (int i = 0; i < 30; i++) {
      // Tìm trong 30 ngày tới
      DateTime currentDate = checkDate.add(Duration(days: i));
      if (currentDate.weekday == DateTime.sunday) continue; // Bỏ qua Chủ Nhật

      // Lọc ca trống cho giảng viên vào ngày này
      final occupiedPeriodsOnDate = mockSchedules
          .where(
            (s) =>
                s.instructorId == widget.user.id &&
                s.date.year == currentDate.year &&
                s.date.month == currentDate.month &&
                s.date.day == currentDate.day,
          )
          .expand((s) => s.periods)
          .toSet();

      final availablePeriodsForDay = _allPossiblePeriodOptions.where((option) {
        return !option.any((p) => occupiedPeriodsOnDate.contains(p));
      }).toList();

      if (availablePeriodsForDay.isEmpty)
        continue; // Nếu ngày này hết ca trống -> bỏ qua

      // Với mỗi ca trống, tìm phòng trống
      for (final periodOption in availablePeriodsForDay) {
        final occupiedRooms = mockSchedules
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
          // ĐÃ TÌM THẤY!
          setState(() {
            _selectedDate = currentDate;
            _selectedPeriods = periodOption;
            _selectedRoomId = availableRoomForPeriod.first;
            _filterAvailablePeriods(); // Cập nhật lại UI list ca học
            _filterAvailableRooms(); // Cập nhật lại UI list phòng
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

    // Nếu không tìm thấy
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

    setState(() {
      final index = mockSchedules.indexWhere((s) => s.id == widget.schedule.id);
      if (index != -1) {
        mockSchedules[index].makeupDate = _selectedDate;
        mockSchedules[index].makeupPeriods = _selectedPeriods;
        mockSchedules[index].makeupRoomId = _selectedRoomId;
        mockSchedules[index].makeupStatus = 'pending_makeup';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gửi yêu cầu dạy bù thành công.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
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
    final bool isPending = widget.schedule.makeupStatus == 'pending_makeup';
    final String pageTitle = isPending
        ? 'Chi tiết đơn dạy bù'
        : 'Đăng ký dạy bù';
    final String buttonLabel = isPending ? 'Cập nhật đơn' : 'Gửi yêu cầu';

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Học phần: ${widget.schedule.subjectName} (${widget.schedule.className})',
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
              // THÊM NÚT GỢI Ý VÀO ĐÂY
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
                        color: _isFindingSuggestion
                            ? Colors.grey
                            : Colors.orange,
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
              _buildDatePicker(),
              const SizedBox(height: 24),
              _buildAnimatedPeriodSelector(),
              const SizedBox(height: 24),
              _buildAnimatedRoomSelector(),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitMakeupRequest,
                  icon: const Icon(Icons.send),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày học:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
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

  Widget _buildAnimatedPeriodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ca học:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        if (_selectedDate == null)
          const Text(
            'Vui lòng chọn ngày trước',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        if (_selectedDate != null && _availablePeriodOptions.isEmpty)
          const Text(
            'Không có ca học nào phù hợp còn trống trong ngày này.',
            style: TextStyle(color: Colors.red),
          ),
        if (_selectedDate != null && _availablePeriodOptions.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _availablePeriodOptions.map((periodOption) {
                final isSelected =
                    _selectedPeriods != null &&
                    _selectedPeriods!.join() == periodOption.join();
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPeriods = isSelected ? null : periodOption;
                        _filterAvailableRooms();
                      });
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withAlpha((255 * 0.3).round()),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Tiết ${periodOption.join('-')}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedRoomSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phòng học:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        if (_selectedPeriods == null)
          const Text(
            'Vui lòng chọn ca học trước',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        if (_selectedPeriods != null && _availableRoomOptions.isEmpty)
          const Text(
            'Không có phòng học nào còn trống vào ca này.',
            style: TextStyle(color: Colors.red),
          ),
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
                        _selectedRoomId = isSelected ? null : room;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withAlpha((255 * 0.3).round()),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        room,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
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
    required Widget child,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: textTheme.bodySmall?.color?.withAlpha((255 * 0.7).round()),
          ),
          const SizedBox(width: 16),
          if (label != null)
            Text(label, style: textTheme.bodyMedium?.copyWith(fontSize: 18)),
          Expanded(
            child: DefaultTextStyle(
              style: textTheme.bodyMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
        Icon(icon, size: 22, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
