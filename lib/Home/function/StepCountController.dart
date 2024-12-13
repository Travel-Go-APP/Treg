import 'dart:io';

import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/repository/StepCountRepository.dart';

abstract class StepCountController extends GetxController {
  final examines = Get.put(examine());

  // 걸음수를 저장할 변수
  final _stepCount = 0.obs;

  // 걸음수 보상 카운트
  RxInt rewardCount = 0.obs;


  // 현재 걸음수를 가져오는 함수
  int get stepCount => _stepCount.value;
  set stepCount(int value) => _stepCount.value = value;

  @override
  void onInit() {
    super.onInit();
    ever(_stepCount, (callback) => print("걸음수가 변동되었습니다."));
  }

  void onStepCount(int step) => _onStepCount(step);
  void saveStepCount() => _saveStepCount();
  void startStepCountTracking() => _startStepCountTracking();
  void saveInitialStepCount(int initialStep) => _saveInitialStepCount(initialStep);
  Future<int?> getInitialStepCountFromDB() => _getInitialStepCountFromDB();
  Future<int?> getTodayStepCount() => _getTodayStepCount();

  void _onStepCount(int steps) {
    stepCount = steps;

    // 활동하고 있을때,
    if (examines.Gauge.value < 100) {
      examines.updateGauge();
    }
    _saveStepCount();
  }

  void _startStepCountTracking();

  void _saveStepCount() {
    StepCountRepository.saveStepCount(stepCount, DateTime.now().toString());
  }

  void _saveInitialStepCount(int initialStep) {
    StepCountRepository.saveInitialStepCount(initialStep, DateTime.now().toString());
  }

  Future<int?> _getTodayStepCount() async {
    int? initialStepCount = await StepCountRepository.getTodayStepCount((DateTime.now().day).toString());
    return initialStepCount;
  }

  Future<int?> _getInitialStepCountFromDB() async {
    int? initialStepCount = await StepCountRepository.getInitialStepCountFromDB();
    return initialStepCount;
  }
}
