import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:rep_records/constants/common.dart';

class SetData {
  final int setNumber;
  final int reps;
  final double weight;

  SetData({
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'reps': reps,
        'weight': weight,
      };

  factory SetData.fromJson(Map<String, dynamic> json) => SetData(
        setNumber: json['setNumber'] as int,
        reps: json['reps'] as int,
        weight: (json['weight'] as num).toDouble(),
      );
}

class ExerciseLogsSetData {
  final List<SetData> sets;

  ExerciseLogsSetData({required this.sets});

  Map<String, dynamic> toJson() => {
        'sets': sets.map((set) => set.toJson()).toList(),
      };

  factory ExerciseLogsSetData.fromJson(Map<String, dynamic> json) => ExerciseLogsSetData(
        sets: (json['sets'] as List)
            .map((set) => SetData.fromJson(set as Map<String, dynamic>))
            .toList(),
      );
}

class ExerciseLogsSetsDataConverter extends TypeConverter<ExerciseLogsSetData, String> {
  const ExerciseLogsSetsDataConverter();

  @override
  ExerciseLogsSetData fromSql(String fromDb) {
    return ExerciseLogsSetData.fromJson(json.decode(fromDb));
  }

  @override
  String toSql(ExerciseLogsSetData value) {
    return json.encode(value.toJson());
  }
}

class ExerciseLog extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get exerciseId => text()();
  TextColumn get sessionDate => text()();
  TextColumn get setsData => text().map(const ExerciseLogsSetsDataConverter())();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('created'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
} 