import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSelectionSheet extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime initialSelectedDate;

  const CalendarSelectionSheet({
    super.key,
    required this.onDateSelected,
    required this.initialSelectedDate,
  });

  @override
  State<CalendarSelectionSheet> createState() => _CalendarSelectionSheetState();
}

class _CalendarSelectionSheetState extends State<CalendarSelectionSheet> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedDate;
    _selectedDay = widget.initialSelectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.75; // Use 75% of screen height
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: 500,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppTheme>()!.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Select Date',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Calendar
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar<DateTime>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()?.text ?? Colors.white,
                  ),
                  defaultTextStyle: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()?.text ?? Colors.white,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.shade600,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).extension<AppTheme>()?.text ?? Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).extension<AppTheme>()?.text ?? Colors.white,
                  ),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()?.text ?? Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()?.text.withOpacity(0.7) ?? Colors.white70,
                  ),
                  weekendStyle: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()?.text.withOpacity(0.7) ?? Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDateSelected(_selectedDay);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Select Date',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 