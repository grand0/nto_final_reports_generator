import 'dart:convert';

import 'package:get/get.dart';

class ApiProvider extends GetConnect {
  static const String url = 'http://188.225.86.14:8000/api';

  Future<void> send(Map<String, bool> condition) async {
    final resp = await post('$url/condition', jsonEncode(condition));
    if (resp.status.hasError) {
      return Future.error(resp.statusText ?? '');
    }
  }
}