import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class packinfo extends GetxController {
  String version = "";

  Future<void> loading() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}
