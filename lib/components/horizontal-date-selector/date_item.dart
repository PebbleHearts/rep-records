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

    bool isDateSelected = formattedDateString == selectedDate;

    return InkWell(
      onTap: () => onDateTap(dateObject),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 50,
        height: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isDateSelected ? FontWeight.bold : FontWeight.normal,
                color: isDateSelected ? Colors.black : Colors.white,
              ),
            ),
            Text(
              formattedDay,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isDateSelected ? FontWeight.bold : FontWeight.normal,
                color: isDateSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
