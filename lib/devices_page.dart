import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nto_final_reports_generator/devices_controller.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DevicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сопряженные устройства'),
        actions: [
          IconButton(
            onPressed: () {
              controller.getDevices();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: controller.obx(
        (devices) {
          return ListView(
            children: devices
                    ?.map(
                      (d) => ListTile(
                        title: Text(d.name ?? '<НЕИЗВЕСТНОЕ ИМЯ>'),
                        subtitle: Text(d.address),
                        onTap: () {
                          SchedulerBinding.instance?.addPostFrameCallback(
                            (_) {
                              Get.toNamed('/', arguments: d.address);
                            },
                          );
                        },
                      ),
                    )
                    .toList() ??
                [],
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (err) => Center(child: Text('ERROR: $err')),
      ),
    );
  }
}
