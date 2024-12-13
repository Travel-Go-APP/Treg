import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
// import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_go/Attraction/function/attractionController.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/dialog/dialog_location.dart';
import 'package:travel_go/Home/ui/event_examine.dart';

class LatLngController extends GetxController {
  final examines = Get.put(examine()); // 게이지 컨트롤러
  final events = Get.put(event()); // 이벤트 컨트롤러
  RxInt examcount = 0.obs; // 이벤트 마커 카운트
  RxDouble searchAble = 0.0002.obs;
  // 광화문을 디폴트로?
  RxDouble mylatitude = 37.571648599.obs; // 위도
  RxDouble mylongitude = 126.976372775.obs; // 경도
  RxBool _moving = false.obs; // 지도를 움직였을때,
  RxBool get moving => _moving;
  late NLocationOverlay locationOverlay;
  NOverlayImage eventImage =
      const NOverlayImage.fromAssetImage("assets/images/event.png");

  NOverlayImage locationImage =
      const NOverlayImage.fromAssetImage("assets/images/location.png");

  Future<void> updatemoving(bool check) async {
    _moving.value = check;
  }

  Future<void> updateLatLng(
      double latitude, double longitude, BuildContext context) async {
    mylatitude.value = latitude;
    mylongitude.value = longitude;
    locationOverlay.setPosition(NLatLng(mylatitude.value, mylongitude.value));
    if (_moving.value == false) {
      final cameraUpdate = NCameraUpdate.withParams(
          target: NLatLng(mylatitude.value, mylongitude.value),
          zoom: 17,
          bearing: 12);
      mapController.updateCamera(cameraUpdate);
    }

    print("위치 변경");
  }

  // 네이버 지도 Default
  NCameraPosition maplatlng = const NCameraPosition(
    target: NLatLng(37.5667, 126.9784), //위치 값 (default : 서울시청)
    zoom: 18, // 카메라 확대
    bearing: 12, // 방위각
    tilt: 0, // 기울기
  );
  late NaverMapController mapController; //카카오맵 컨트롤러

  // 위치 권한 및 현 위치 가져오기
  Future<void> checkLocation(BuildContext context) async {
    final locationStatus = await Permission.location.status; // 위치 권한 상태 확인
    final activityStatusAndroid = await Permission
        .activityRecognition.status; // 활동 권한 상태 확인 (Android - 걸음수)
    final activityStatusIos =
        await Permission.sensors.status; // 센서 권한 상태 확인 (Ios - 걸음수)

    // 권한 거부일때
    if (Platform.isAndroid) {
      if (locationStatus.isDenied || activityStatusAndroid.isDenied) {
        if (context.mounted) {
          dialogLocation(
              context, locationStatus, activityStatusAndroid); // 권한 동의 화면
        }
      } else {
        print('Android 권한 확인 완료');
        getMap(context); // 위치 추적 모드
      }
    } else if (Platform.isIOS) {
      if (locationStatus.isDenied || activityStatusIos.isDenied) {
        if (context.mounted) {
          dialogLocation(
              context, locationStatus, activityStatusIos); // 권한 동의 화면
        }
      } else {
        print('Ios 권한 확인 완료');
        getMap(context); // 위치 추적 모드
      }
    }
  }

  // // 현재 위치 가져오기 (Geolocator 사용)
  // Future<void> getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best, // 위치 정확도 수치
  //     forceAndroidLocationManager: true,
  //   );
  //   mylatitude.value = position.latitude; // 위도
  //   mylongitude.value = position.longitude; // 경도
  // }

  // 위치 추적 모드
  Future<void> getMap(BuildContext context) async {
    locationOverlay = await mapController.getLocationOverlay(); // 현위치 오버레이
    locationOverlay.setIconSize(Platform.isAndroid
        ? Size.fromRadius(MediaQuery.of(context).size.width * 0.035)
        : Size.fromRadius(MediaQuery.of(context).size.width * 0.1)); // 아이콘 사이즈
    locationOverlay.setCircleOutlineWidth(2); // 테두리 굵기
    locationOverlay.setCircleRadius(MediaQuery.of(context).size.width *
            MediaQuery.of(context).size.height *
            searchAble.value -
        5); // 원 크기
    locationOverlay.setPosition(NLatLng(mylatitude.value, mylongitude.value));
    locationOverlay.setIsVisible(true);
    // print("위도 : ${mylatitude}, 경도 : ${mylongitude}");
    final cameraUpdate = NCameraUpdate.withParams(
        target: NLatLng(mylatitude.value, mylongitude.value),
        zoom: 17,
        bearing: 12);
    await mapController.updateCamera(cameraUpdate);
    // locationOverlay.setIcon(const NOverlayImage.fromAssetImage('assets/images/user.png'));
    // await getLocation(); // 현재 위치 가져오기 (위경도)
    // mapController.setLocationTrackingMode(NLocationTrackingMode.follow); // 현재 위치 가져오기 (Naver Map Api)
  }

  Future<void> setCircleVisible(bool moveing) async {
    locationOverlay.setCircleColor(moveing
        ? Colors.transparent
        : const Color.fromARGB(119, 114, 255, 111));
    locationOverlay.setCircleOutlineColor(
        moveing ? Colors.transparent : Colors.black); // 테두리 색상
  }

  // 이벤트 마커 생성
  Future<void> addMarker(BuildContext context) async {
    //새로운 위치 정보 생성
    double newLatitude = mylatitude.value + randomLatitude();
    double newLongitude = mylongitude.value + randomLongitude();

    examcount.value++; // 마커 id 값 증가

    // 마커 id 랜덤 난수 적용
    final random = Random();
    int randomid = 1000 + random.nextInt(10000 - 100 + 1);

    // 이벤트 마커 사이즈
    Size eventIconSize =
        Size.fromRadius(MediaQuery.of(context).size.width * 0.045);

    // 새로운 위치 정보로 Marker 생성
    NMarker marker = NMarker(
        icon: eventImage,
        size: eventIconSize,
        id: "$randomid",
        position: NLatLng(newLatitude, newLongitude));
    mapController.addOverlay(marker);

    // 마커를 클릭했을때,
    marker.setOnTapListener((overlay) async {
      double m = meter(overlay.position.latitude,
          overlay.position.longitude); // 현위치 - 마커 직선거리
      print("마커까지 거리 : $m");
      double minMeter = MediaQuery.of(context).size.width *
              MediaQuery.of(context).size.height *
              searchAble.value -
          30;
      print("범위 거리 : $minMeter");
      final userDate = Get.put(userController()); // 사용자 정보 컨트롤러

      // 범위내에 들어가고,
      if (m <= minMeter) {
        // 조사하기 횟수가 최소 1개 이상일때 이벤트 처리
        if (userDate.userPossibleSearch >= 1) {
          examines.randomExamine(context, marker.info.id);
          // 카운트가 모자르다고 알림
        } else {
          events.noCountSearch(context);
        }
      } else {
        events.failExamine(context, m, minMeter, marker.info.id);
      }
      // mapController.deleteOverlay(marker.info);
    });
  }

  // 명소 마커 생성
  Future<void> addLocationMarker(BuildContext context, double latitude,
      double longitude, int locationID) async {
    // 이벤트 마커 사이즈
    Size eventIconSize =
        Size.fromRadius(MediaQuery.of(context).size.width * 0.045);

    // 새로운 위치 정보로 Marker 생성
    NMarker marker = NMarker(
        icon: locationImage,
        size: eventIconSize,
        id: "$locationID",
        position: NLatLng(latitude, longitude));
    mapController.addOverlay(marker);

    events.addMapAttraction(context);

    // 마커를 클릭했을때,
    marker.setOnTapListener((overlay) async {
      double m = meter(overlay.position.latitude,
          overlay.position.longitude); // 현위치 - 마커 직선거리
      print("마커까지 거리 : $m");
      double minMeter = MediaQuery.of(context).size.width *
              MediaQuery.of(context).size.height *
              searchAble.value -
          30;
      print("범위 거리 : $minMeter");
      final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
      final attraction = Get.put(attractionController());

      // 범위내에 들어가고,
      if (m <= minMeter) {
        // 조사하기 횟수가 최소 1개 이상일때 이벤트 처리
        if (userDate.userPossibleSearch >= 1) {
          print("명소 획득 !");
          attraction.getAttraction(context, locationID);
          examines.addAttractionMarker.value = false;
          attraction.visitAttraction(locationID);
          mapController.deleteOverlay(marker.info);
        } else {
          events.noCountSearch(context);
        }
      } else {
        events.failExamine(context, m, minMeter, marker.info.id);
      }
    });
  }

  // 랜덤 경도
  double randomLatitude() {
    double randomLatitudeOffset = (Random().nextDouble() * 0.0003) + 0.0001;
    double randomLatitudebool =
        Random().nextBool() ? randomLatitudeOffset : -randomLatitudeOffset;
    return randomLatitudebool;
  }

  // 랜덤 위도
  double randomLongitude() {
    double randomLongitudeOffset = (Random().nextDouble() * 0.0003) + 0.0001;
    double randomLongitudebool =
        Random().nextBool() ? randomLongitudeOffset : -randomLongitudeOffset;
    return randomLongitudebool;
  }

  // 두 좌표간의 거리
  double meter(double newLatitude, double newLongitude) {
    double meter = const Distance().as(
      LengthUnit.Meter,
      LatLng(mylatitude.value, mylongitude.value),
      LatLng(newLatitude, newLongitude),
    );

    return meter;
  }
}
