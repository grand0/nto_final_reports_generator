enum ContainerDevice {
  servoRed,
  servoGreen,
  servoBlue,
  typeRed,
  typeGreen,
  typeBlue,
  overflowRed,
  overflowGreen,
  overflowBlue,
}

extension ContainerDeviceExt on ContainerDevice {
  String getJsonName() {
    return toString().split('.').last;
  }

  String getTableName() {
    switch (this) {
      case ContainerDevice.servoRed:
        return 'Сервопривод (пластик)';
      case ContainerDevice.servoGreen:
        return 'Сервопривод (бумага)';
      case ContainerDevice.servoBlue:
        return 'Сервопривод (стекло)';
      case ContainerDevice.typeRed:
        return 'Датчик пластика';
      case ContainerDevice.typeGreen:
        return 'Датчик бумаги';
      case ContainerDevice.typeBlue:
        return 'Датчик стекла';
      case ContainerDevice.overflowRed:
        return 'Датчик переполнения пластика';
      case ContainerDevice.overflowGreen:
        return 'Датчик переполнения бумаги';
      case ContainerDevice.overflowBlue:
        return 'Датчик переполнения стекла';
    }
  }
}