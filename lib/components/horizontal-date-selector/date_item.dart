import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateItem extends StatelessWidget {
  final DateTime dateObject;
  final String selectedDate;
  final ValueSetter<DateTime> onDateTap;
  const DateItem({
    super.key,
    required this.dateObject,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE').format(dateObject);
    String formattedDay = DateFormat('d').format(dateObject);
    String formattedDateString = DateFormat('dd-MM-yyyy').format(dateObject);
    
    // Check if this date is today
    final today = DateTime.now();
    final todayFormatted = DateFormat('dd-MM-yyyy').format(today);
    bool isToday = formattedDateString == todayFormatted;

    bool isDateSelected = formattedDateString == selectedDate;

    // Determine colors based on state
    Color backgroundColor;
    Color textColor;
    FontWeight fontWeight;
    
    if (isDateSelected && isToday) {
      // Selected date that is also today - use today's color
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.teal.shade600; // Teal color for today
      fontWeight = FontWeight.bold;
    } else if (isDateSelected) {
      // Selected date - primary color
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (isToday) {
      // Today's date - only teal text
      backgroundColor = Colors.transparent;
      textColor = Colors.teal.shade600;
      fontWeight = FontWeight.w600;
    } else {
      // Regular date
      backgroundColor = Colors.transparent;
      textColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;
      fontWeight = FontWeight.normal;
    }

    return InkWell(
      onTap: () => onDateTap(dateObject),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 50,
        height: 45,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 11,
                fontWeight: fontWeight,
                color: textColor.withOpacity(0.8),
              ),
            ),
            Text(
              formattedDay,
              style: TextStyle(
                fontSize: 13,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
