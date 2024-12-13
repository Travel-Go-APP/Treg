import 'dart:io';

// import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_go/Home/function/StepCountController.dart';

class StepCounterIOSController extends StepCountController {
  // @override
  // Future<void> startStepCountTracking() async {
  //   if (Platform.isIOS) {
  //     // 권한 확인
  //     var status = await Permission.health.status;
  //     if (status != PermissionStatus.granted) {
  //       // 권한 요청
  //       status = await Permission.health.request();
  //       if (status != PermissionStatus.granted) {
  //         // 권한 요청 거부 시 처리
  //         return;
  //       }
  //     }

  //     final healthKitReporter = HealthKitReporter();
  //     healthKitReporter.getTodayStepCount().then((stepCount) {
  //       onStepCount(stepCount);
  //     });
  //   }
  // }
}