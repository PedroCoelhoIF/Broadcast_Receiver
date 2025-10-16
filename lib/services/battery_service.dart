import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import '../models/battery_model.dart';

class BatteryService {
  final Battery _battery = Battery();
  
  // EventChannel para receber dados do Broadcast Receiver nativo
  static const EventChannel _batteryChannel = 
      EventChannel('com.example.battery_monitor/battery');

  // Obtém o nível atual da bateria usando battery_plus
  Future<BatteryModel> getBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;
    
    return BatteryModel(
      level: level,
      isCharging: state == BatteryState.charging || state == BatteryState.full,
    );
  }

  // Stream do battery_plus (fallback)
  Stream<BatteryState> get batteryStateStream => _battery.onBatteryStateChanged;

  // Stream do Broadcast Receiver nativo (método principal)
  Stream<BatteryModel> get batteryBroadcastStream {
    return _batteryChannel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> data = event as Map<dynamic, dynamic>;
      return BatteryModel(
        level: data['level'] as int,
        isCharging: data['isCharging'] as bool,
      );
    }).handleError((error) {
      // Se houver erro com o canal nativo, usa o battery_plus como fallback
      print('Erro no Broadcast Receiver: $error');
      return getBatteryInfo().asStream();
    });
  }
}