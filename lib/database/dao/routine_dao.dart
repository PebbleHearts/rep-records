import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/routine.dart';

part 'routine_dao.g.dart';

@DriftAccessor(tables: [Routines])
class RoutineDao extends DatabaseAccessor<AppDatabase> with _$RoutineDaoMixin {
  RoutineDao(super.database);

  Future<List<Routine>> getAllRoutines() => select(routines).get();
  
  Future<int> createRoutine(RoutinesCompanion routine) => 
      into(routines).insert(routine);

  Future<bool> updateRoutine(RoutinesCompanion routine) =>
      update(routines).replace(routine);

  Future<int> deleteRoutine(int id) =>
      (delete(routines)..where((r) => r.id.equals(id))).go();
} 