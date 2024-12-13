import 'dart:async';
import 'dart:io';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_go/Home/function/StepCountController.dart';

class StepCounterAndroidController extends StepCountController {

  int _previousSteps = 0;
  int _initialSteps = 0;
  StreamSubscription<StepCount>? _stepCountSubscription;
  
  DateTime _lastSyncedDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    startStepCountTracking();
  }
  
  @override
  void startStepCountTracking() async {
    if (Platform.isAndroid) {
      // 권한 확인

      _initialSteps = await getInitialStepCountFromDB() ?? 0;
      _previousSteps = (await getTodayStepCount())!;

      //기존 값에서 이전에 스트림된 step값에 현재 step값의 타이를 변수에 더하기 or DB에 저장하면서 업데이트
      print("트래킹 시작");

      // 걸음 수 트래킹 시작
      _stepCountSubscription = Pedometer.stepCountStream.listen((event) async {
        onStepCount(event.steps - _initialSteps);
      });
    }
  }

  @override
  void onStepCount(int step) async {
    _previousSteps = (await getTodayStepCount())!;
    _checkDaily();
    super.onStepCount(_previousSteps + step);
  }

  // 걸음수를 초기화하는 함수
  void resetSteps() {
    stepCount = 0;
  }

  void _checkDaily() async {
    final now = DateTime.now();
    if (_isNextDay(now)) {
      resetSteps();
      _lastSyncedDate = now;
      _initialSteps = await _getInitialStepCount();
    }
  }

  bool _isNextDay(DateTime now) {
    return now.day != _lastSyncedDate.day;
  }

  Future<int> _getInitialStepCount() async {
    final StepCount initialStepCount = await Pedometer.stepCountStream.last;
    saveInitialStepCount(initialStepCount.steps);
    return initialStepCount.steps;
  }
  

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    super.dispose();
  }
}