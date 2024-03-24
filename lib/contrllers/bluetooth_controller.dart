import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  RxList<ScanResult> scanResults = <ScanResult>[].obs;

  Future<void> scanDevice() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    var subscription = FlutterBluePlus.scanResults.listen((results) {
      scanResults.assignAll(results);
      print("SCANRESULT: $results");
    });
    await Future.delayed(const Duration(seconds: 10));
    await subscription.cancel();
    FlutterBluePlus.stopScan();
  }
}
