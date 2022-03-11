import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController with StateMixin<BluetoothConnection> {
  String address;

  ConnectionController(this.address) {
    connect();
    // change(null, status: RxStatus.success());
  }

  @override
  void onClose() {
    state?.finish();
    super.onClose();
  }

  void connect() async {
    change(null, status: RxStatus.loading());
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(address);
      change(connection, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void sendData(String message) {
    state?.output.add(Uint8List.fromList(message.codeUnits));
  }
}