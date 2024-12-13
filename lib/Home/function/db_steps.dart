import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:intl/intl.dart';

class dbSteps extends GetxController with WidgetsBindingObserver {
  final examines = Get.put(examine()); // 게이지 컨트롤러
  late Stream<StepCount> _stepCountStream; // pedometer
  late Box _stepBox; // steps 데이터베이스
  RxInt steps = 0.obs; // 걸음수
  int? _initialSteps = 0;
  int? currentSteps = 0;
  int? calibratedSteps = 0;
  String _status = 'Unknown';
  // int w = 0; // 가중치

  void onlnit() {
    super.onInit();
    ever(steps, (callback) => print("걸음수가 변동되었습니다."));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAndResetSteps();
    }
  }

  void initPlatformState(BuildContext context) {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    _stepBox = Hive.box('stepBox');
    checkAndResetSteps();

    _initialSteps = _stepBox.get('initialSteps', defaultValue: null);
    if (_initialSteps == null) {
      _status = 'Calibrating...';
      print(_status);
    } else {
      steps(_stepBox.get('steps', defaultValue: 0));
    }

    if (context.mounted) return;
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  // 걸음수 카운팅
  void onStepCount(StepCount event) {
    currentSteps = event.steps;

    if (_initialSteps == null) {
      // First run, set initial steps
      _initialSteps = currentSteps;
      _stepBox.put('initialSteps', _initialSteps);
      _status = 'Calibrated';
      print(_status);
    }

    checkAndResetSteps();

    int calculatedSteps = currentSteps! - _initialSteps! + calibratedSteps!;
    if (calculatedSteps < 0) {
      // Device reboot detected, recalibrate
      calibratedSteps = _stepBox.get('steps', defaultValue: 0);
      _initialSteps = 0;
      _stepBox.put('initialSteps', _initialSteps);
      calculatedSteps = currentSteps! - _initialSteps! + calibratedSteps!;
    }

    putNumber(calculatedSteps);
    _stepBox.put('steps', steps);
  }

  // 카운팅 (상태관리)
  void putNumber(int value) {
    steps(value);
    // 활동하고 있을때,
    if (examines.Gauge.value < 100) {
      examines.updateGauge();
    }
  }

  void checkAndResetSteps() {
    String lastResetDate = _stepBox.get('lastResetDate', defaultValue: '');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastResetDate != today) {
      steps(0);
      calibratedSteps = 0;
      _stepBox.put('steps', 0);
      _stepBox.put('lastResetDate', today);
      _initialSteps = currentSteps;
      _stepBox.put('initialSteps', _initialSteps);
    }
  }
}
