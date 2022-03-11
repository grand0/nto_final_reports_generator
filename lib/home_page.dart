import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nto_final_reports_generator/checklist_controller.dart';
import 'package:nto_final_reports_generator/connection_controller.dart';
import 'package:nto_final_reports_generator/container_device.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null || Get.arguments is! String) {
      Get.offNamed('/devices');
    }

    ConnectionController controller =
        Get.put(ConnectionController(Get.arguments));

    final checklistController = Get.put(ChecklistController());
    List<String> names =
        ContainerDevice.values.map((e) => e.getTableName()).toList();
    List<String> jsonNames =
        ContainerDevice.values.map((e) => e.getJsonName()).toList();
    Map<String, String> messages = {
      'servoRed': '',
      'servoGreen': '',
      'servoBlue': '',
      'typeRed': '',
      'typeGreen': '',
      'typeBlue': '',
      'overflowRed': '',
      'overflowGreen': '',
      'overflowBlue': '',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Генератор отчёта'),
      ),
      body: controller.obx(
        (conn) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return TestingRow(
                    onChanged: (value) {
                      checklistController.changeFlag(jsonNames[index], value);
                    },
                    title: names[index],
                    onButtonPressed: () {
                      controller.sendData(messages[names[index]]!);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                checklistController.send();
              },
              child: const Text('Отправить отчёт'),
            ),
          ],
        ),
        onError: (err) => Center(child: Text('Ошибка: $err')),
        onLoading: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class TestingRow extends StatefulWidget {
  final void Function(bool value) onChanged;
  final String title;
  final void Function() onButtonPressed;

  const TestingRow({
    Key? key,
    required this.onChanged,
    required this.title,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  State<TestingRow> createState() => _TestingRowState();
}

class _TestingRowState extends State<TestingRow> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: value,
        onChanged: (bool? value) {
          setState(() {
            this.value = value ?? true;
          });
          widget.onChanged(this.value);
        },
      ),
      title: Text(widget.title),
      trailing: TextButton(
        onPressed: () => widget.onButtonPressed,
        child: const Text('Тест'),
      ),
    );
  }
}
