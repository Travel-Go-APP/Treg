import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class StepCountModel extends HiveObject {
  @HiveField(0)
  int stepCount;

  @HiveField(1)
  String date;

  StepCountModel({required this.stepCount, required this.date});
}