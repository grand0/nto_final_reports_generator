import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nto_final_reports_generator/checklist_controller.dart';
import 'package:nto_final_reports_generator/connection_controller.dart';
import 'package:nto_final_reports_generator/container_device.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = Get.arguments;

    if (address == null || address is! String) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed('/devices');
      });
    }

    ConnectionController controller = Get.put(ConnectionController(address));

    final checklistController = Get.put(ChecklistController());
    List<String> names =
        ContainerDevice.values.map((e) => e.getTableName()).toList();
    List<String> jsonNames =
        ContainerDevice.values.map((e) => e.getJsonName()).toList();
    Map<String, String> messages = {
      'servoRed': 's/r',
      'servoGreen': 's/g',
      'servoBlue': 's/b',
      'typeRed': 't/r',
      'typeGreen': 't/g',
      'typeBlue': 't/b',
      'overflowRed': 'o/r',
      'overflowGreen': 'o/g',
      'overflowBlue': 'o/b',
    };

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Генератор отчёта'),
            Text(
              address,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
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
                      controller.sendData('${messages[names[index]]!}/1/');
                    },
                    onButtonLongPress: () {
                      controller.sendData('${messages[names[index]]!}/0/');
                    },
                  );
                },
              ),
            ),
            checklistController.obx(
              (_) => Column(
                children: [
                  const Text(
                    'Успешно',
                    style: TextStyle(color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checklistController.send();
                    },
                    child: const Text('Отправить отчёт'),
                  ),
                ],
              ),
              onEmpty: ElevatedButton(
                onPressed: () {
                  checklistController.send();
                },
                child: const Text('Отправить отчёт'),
              ),
              onLoading: const CircularProgressIndicator(),
              onError: (err) => Column(
                children: [
                  Text(
                    err ?? 'Неизвестная ошибка',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checklistController.send();
                    },
                    child: const Text('Отправить отчёт'),
                  ),
                ],
              ),
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
  final void Function() onButtonLongPress;

  const TestingRow({
    Key? key,
    required this.onChanged,
    required this.title,
    required this.onButtonPressed,
    required this.onButtonLongPress,
  }) : super(key: key);

  @override
  State<TestingRow> createState() => _TestingRowState();
}

class _TestingRowState extends State<TestingRow> {
  bool value = false;

  void changeValue(bool value) {
    setState(() {
      this.value = value;
    });
    widget.onChanged(this.value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: value,
        onChanged: (bool? value) {
          changeValue(value ?? true);
        },
      ),
      title: Text(widget.title),
      trailing: TextButton(
        onPressed: () => widget.onButtonPressed,
        onLongPress: () => widget.onButtonLongPress,
        child: const Text('Тест'),
      ),
      onTap: () => changeValue(!value),
    );
  }
}
