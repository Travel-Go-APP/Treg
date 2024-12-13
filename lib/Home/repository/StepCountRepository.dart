import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_go/Home/model/StepCountModel.dart';

class StepCountRepository {
  static final _stepCountBox = Hive.box<StepCountModel>('step_count');

  // Future<void> saveStepCount(int stepCount, String date) async {
  //   final stepCountModel = StepCountModel(stepCount: stepCount, date: date);
  //   await _stepCountBox.put(date, stepCountModel);
  // }
  static void saveStepCount(int stepCount, String date) async {
    final stepCountModel = StepCountModel(stepCount: stepCount, date: date);
    await _stepCountBox.put(date, stepCountModel);
    // 파일 저장 또는 DB 저장 등의 구현
    print('Saved step count: $stepCount on $date');
  }

  static void saveInitialStepCount(int stepCount, String date) async {
    final stepCountModel = StepCountModel(stepCount: stepCount, date: date);
    await _stepCountBox.put('initial_steps', stepCountModel);
    // 파일 저장 또는 DB 저장 등의 구현
    print('Saved Initial step count: $stepCount on $date');
  }

  static Future<int> getTodayStepCount(String date) async {
    final stepCountModel = await _stepCountBox.get(date);
    return stepCountModel?.stepCount ?? 0;
  }

  static Future<int?> getInitialStepCountFromDB() async {
    final stepCountModel = await _stepCountBox.get('initial_steps');
    return stepCountModel?.stepCount;
  }
}