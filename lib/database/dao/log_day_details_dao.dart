import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/log_day_details.dart';

part 'log_day_details_dao.g.dart';

@DriftAccessor(tables: [LogDayDetails])
class LogDayDetailsDao extends DatabaseAccessor<AppDatabase> with _$LogDayDetailsDaoMixin {
  LogDayDetailsDao(super.database);

  Future<List<LogDayDetail>> getAllLogDayDetails() async {
    return (select(logDayDetails)..where((t) => t.status.isNotValue('deleted'))).get();
  }

  Future<List<LogDayDetail>> getAllUnSyncedLogDayDetails() async {
    return (select(logDayDetails)..where((t) => t.synced.equals(false))).get();
  }

  Stream<List<LogDayDetail>> watchAllLogDayDetails() {
    return (select(logDayDetails)..where((t) => t.status.isNotValue('deleted'))).watch();
  }

  Future<LogDayDetail?> getLogDayDetailsByDate(String date) async {
    final query = select(logDayDetails)..where((t) => t.sessionDate.equals(date) & t.status.isNotValue('deleted'));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> insertLogDayDetails(LogDayDetailsCompanion logDayDetailsData) async {
    await into(logDayDetails).insert(logDayDetailsData);
  }

  Future<void> updateLogDayDetails(LogDayDetailsCompanion logDayDetailsData) async {
    await (update(logDayDetails)..where((t) => t.id.equals(logDayDetailsData.id.value)))
        .write(logDayDetailsData.copyWith(
          updatedAt: Value(DateTime.now()),
          synced: const Value(false),
        ));
  }

  Future<void> deleteLogDayDetails(String id) async {
    await (update(logDayDetails)..where((t) => t.id.equals(id))).write(
      LogDayDetailsCompanion(
        status: const Value('deleted'),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateSynced(List<String> logDayDetailsIds) async {
    await (update(logDayDetails)..where((t) => t.id.isIn(logDayDetailsIds)))
        .write(LogDayDetailsCompanion(synced: const Value(true)));
  }
} 