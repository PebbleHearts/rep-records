import 'package:drift/drift.dart';

@DataClassName('Routine')
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  
  @override
  Set<Column> get primaryKey => {id};
} 