import 'package:drift/drift.dart';

@DataClassName('Routine')
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get status => text()(); // Can be 'active' or 'archived'
  
  @override
  Set<Column> get primaryKey => {id};
} 