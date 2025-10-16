import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/light_theme.dart';
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
import '../../data/mock_data.dart';

class ScheduleCell {
  final String subjectName;
  final String room;
  final int period;
  final int dayOfWeek;

  ScheduleCell({
    required this.subjectName,
    required this.room,
    required this.period,
    required this.dayOfWeek,
  });

  factory ScheduleCell.fromScheduleEntry(ScheduleEntry entry, int period) {
    return ScheduleCell(
      subjectName: entry.subjectName,
      room: entry.roomId,
      period: period,
      dayOfWeek: entry.date.weekday,
    );
  }
}

class WeeklySchedulePage extends StatelessWidget {
  final UserAccount user;

  const WeeklySchedulePage({super.key, required this.user});

  Map<int, Map<int, ScheduleCell>> _processSchedules() {
    final userSchedules = mockSchedules
        .where((s) => s.instructorId == user.id)
        .toList();
    final Map<int, Map<int, ScheduleCell>> scheduleMatrix = {};

    for (final schedule in userSchedules) {
      for (final period in schedule.periods) {
        if (scheduleMatrix[period] == null) {
          scheduleMatrix[period] = {};
        }
        final day = schedule.date.weekday;
        scheduleMatrix[period]![day] = ScheduleCell.fromScheduleEntry(
          schedule,
          period,
        );
      }
    }
    return scheduleMatrix;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleData = _processSchedules();
    final List<String> days = [
      "",
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "CN",
    ];
    final List<Map<String, String>> periods = [
      {"name": "Tiết 1", "time": "(7:00 - 7:50)"},
      {"name": "Tiết 2", "time": "(7:55 - 8:45)"},
      {"name": "Tiết 3", "time": "(8:50 - 9:40)"},
      {"name": "Tiết 4", "time": "(9:45 - 10:35)"},
      {"name": "Tiết 5", "time": "(10:40 - 11:30)"},
      {"name": "Tiết 6", "time": "(11:35 - 12:25)"},
      {"name": "Tiết 7", "time": "(12:55 - 13:45)"},
      {"name": "Tiết 8", "time": "(13:50 - 14:40)"},
      {"name": "Tiết 9", "time": "(14:45 - 15:35)"},
      {"name": "Tiết 10", "time": "(15:40 - 16:30)"},
      {"name": "Tiết 11", "time": "(16:35 - 17:25)"},
      {"name": "Tiết 12", "time": "(17:30 - 18:20)"},
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lịch dạy theo tuần'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(
                    width: 1,
                  ),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(150.0),
                    2: FixedColumnWidth(150.0),
                    3: FixedColumnWidth(150.0),
                    4: FixedColumnWidth(150.0),
                    5: FixedColumnWidth(150.0),
                    6: FixedColumnWidth(150.0),
                    7: FixedColumnWidth(150.0),
                  },
                  children: [
                    TableRow(
                      children: days
                          .map((day) => _buildHeaderCell(day))
                          .toList(),
                    ),
                    ...List.generate(periods.length, (periodIndex) {
                      int currentPeriod = periodIndex + 1;
                      return TableRow(
                        children: List.generate(8, (dayIndex) {
                          if (dayIndex == 0) {
                            return _buildPeriodCell(
                              periods[periodIndex]['name']!,
                              periods[periodIndex]['time']!,
                            );
                          }
                          final cellData = scheduleData[currentPeriod]?[dayIndex];
                          return _buildScheduleCell(cellData);
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[200],
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPeriodCell(String period, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildScheduleCell(ScheduleCell? cell) {
    if (cell == null) {
      return const SizedBox(height: 80);
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cell.subjectName,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            cell.room,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
