import 'package:flutter/material.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/edit-log-screen/edit_log_screen.dart';
import 'package:rep_records/theme/app_theme.dart';

class RoutineSelectionSheet extends StatefulWidget {
  final String selectedDate;

  const RoutineSelectionSheet({
    super.key,
    required this.selectedDate,
  });

  @override
  State<RoutineSelectionSheet> createState() => _RoutineSelectionSheetState();
}

class _RoutineSelectionSheetState extends State<RoutineSelectionSheet> {
  late Future<List<Routine>> _routinesFuture;

  @override
  void initState() {
    super.initState();
    _routinesFuture = RoutineDao(database).getAllRoutines();
  }

  void _handleRoutineSelection(BuildContext context, String routineId, String routineName) {
    Navigator.pop(context); // Close the bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLogScreen(
          routineId: routineId,
          date: widget.selectedDate,
          routineName: routineName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppTheme>()!.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Routine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: FutureBuilder<List<Routine>>(
              future: _routinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Error loading routines: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final routines = snapshot.data ?? [];

                if (routines.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No routines found'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    final routine = routines[index];
                    return ListTile(
                      title: Text(routine.name),
                      onTap: () => _handleRoutineSelection(context, routine.id, routine.name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 