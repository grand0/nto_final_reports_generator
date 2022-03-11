import 'package:get/get.dart';
import 'package:nto_final_reports_generator/api_provider.dart';
import 'package:nto_final_reports_generator/container_device.dart';

class ChecklistController extends GetxController with StateMixin {
  final provider = ApiProvider();
  late Map<String, bool> condition;

  ChecklistController() {
    change(null, status: RxStatus.empty());
    condition = {};
    for (final d in ContainerDevice.values) {
      condition[d.getJsonName()] = false;
    }
  }

  void changeFlag(String name, bool value) {
    condition[name] = value;
  }

  void send() {
    change(null, status: RxStatus.loading());
    provider.send(condition).then(
          (value) => change(null, status: RxStatus.success()),
          onError: (err) {
            final String? errObj = (err == '') ? null : err;
            change(null, status: RxStatus.error(errObj));
          },
        );
  }
}
