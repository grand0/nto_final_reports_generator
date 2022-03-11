import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class DevicesController extends GetxController
    with StateMixin<List<BluetoothDevice>> {
  DevicesController() {
    getDevices();
  }

  void getDevices() {
    change(null, status: RxStatus.loading());
    FlutterBluetoothSerial.instance.getBondedDevices().then(
          (value) => change(value, status: RxStatus.success()),
          onError: (err) => change(null, status: RxStatus.error(err)),
        );
  }
}
