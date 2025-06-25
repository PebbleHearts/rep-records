import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

@DataClassName('Routine')
class Routines extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get name => text()();
  TextColumn get status => text()(); // Can be 'active' or 'archived'
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
} 