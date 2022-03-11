import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'devices_page.dart';
import 'home_page.dart';

void main() => runApp(GetMaterialApp(
  theme: ThemeData.light().copyWith(
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.indigo)),
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.indigo,
    ),
  ),
  debugShowCheckedModeBanner: false,
  title: 'Генератор отчёта',
  initialRoute: '/',
  getPages: [
    GetPage(
      name: '/',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/devices',
      page: () => const DevicesPage(),
    ),
  ],
));