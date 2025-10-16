import 'package:flutter/material.dart';

class BatteryModel {
  final int level;
  final bool isCharging;

  BatteryModel({
    required this.level,
    required this.isCharging,
  });

  bool get isLowBattery => level < 20;

  Color get batteryColor {
    if (isCharging) {
      return const Color(0xFF4CAF50); // Verde para carregando
    } else if (level < 20) {
      return const Color(0xFFF44336); // Vermelho para bateria baixa
    } else if (level < 50) {
      return const Color(0xFFFF9800); // Laranja para bateria média
    } else {
      return const Color(0xFF4CAF50); // Verde para bateria boa
    }
  }

  String get statusText {
    if (isCharging) {
      return 'Carregando';
    } else if (level < 20) {
      return 'Bateria Baixa';
    } else if (level < 50) {
      return 'Bateria Média';
    } else {
      return 'Bateria Boa';
    }
  }
}

