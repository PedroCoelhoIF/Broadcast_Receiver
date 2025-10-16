import 'dart:async';
import 'package:flutter/material.dart';
import '../models/battery_model.dart';
import '../services/battery_service.dart';

class BatteryViewModel extends ChangeNotifier {
  final BatteryService _batteryService = BatteryService();
  BatteryModel? _batteryModel;
  StreamSubscription? _batteryBroadcastSubscription;
  bool _hasShownLowBatteryWarning = false;
  bool _useBroadcastReceiver = true; // Flag para usar Broadcast Receiver

  BatteryModel? get batteryModel => _batteryModel;
  bool get isLoading => _batteryModel == null;
  bool get isUsingBroadcastReceiver => _useBroadcastReceiver;

  BatteryViewModel() {
    _initialize();
  }

  void _initialize() {
    _updateBatteryInfo();
    _startBroadcastReceiverMonitoring();
  }

  // Atualiza as informações da bateria (método inicial)
  Future<void> _updateBatteryInfo() async {
    try {
      final batteryInfo = await _batteryService.getBatteryInfo();
      final previousLevel = _batteryModel?.level;
      
      _batteryModel = batteryInfo;
      notifyListeners();

      // Verifica se deve mostrar aviso de bateria baixa
      if (batteryInfo.isLowBattery && 
          !batteryInfo.isCharging && 
          (previousLevel == null || previousLevel >= 20)) {
        _hasShownLowBatteryWarning = false;
      }
    } catch (e) {
      debugPrint('Erro ao obter informações da bateria: $e');
    }
  }

  // Monitora mudanças através do Broadcast Receiver nativo
  void _startBroadcastReceiverMonitoring() {
    _batteryBroadcastSubscription = 
        _batteryService.batteryBroadcastStream.listen(
      (batteryInfo) {
        final previousLevel = _batteryModel?.level;
        
        _batteryModel = batteryInfo;
        notifyListeners();

        debugPrint('📡 Broadcast Receiver - Bateria: ${batteryInfo.level}% | '
                  'Carregando: ${batteryInfo.isCharging}');

        // Verifica se deve resetar ou mostrar aviso
        if (batteryInfo.isLowBattery && 
            !batteryInfo.isCharging && 
            (previousLevel == null || previousLevel >= 20)) {
          _hasShownLowBatteryWarning = false;
        }
      },
      onError: (error) {
        debugPrint('❌ Erro no Broadcast Receiver: $error');
        _useBroadcastReceiver = false;
        // Fallback para o método tradicional
        _startFallbackMonitoring();
      },
    );
  }

  // Método fallback caso o Broadcast Receiver falhe
  void _startFallbackMonitoring() {
    debugPrint('⚠️ Usando monitoramento fallback (battery_plus)');
    
    Timer.periodic(const Duration(seconds: 30), (_) {
      _updateBatteryInfo();
    });

    _batteryService.batteryStateStream.listen((_) {
      _updateBatteryInfo();
    });
  }

  bool shouldShowLowBatteryWarning() {
    final shouldShow = _batteryModel?.isLowBattery == true && 
        !(_batteryModel?.isCharging ?? false) && 
        !_hasShownLowBatteryWarning;
    
    if (shouldShow) {
      _hasShownLowBatteryWarning = true;
      debugPrint('⚠️ Exibindo alerta de bateria baixa!');
    }
    
    // Reset do aviso quando a bateria voltar acima de 20% ou começar a carregar
    if (_batteryModel != null && 
        (!_batteryModel!.isLowBattery || _batteryModel!.isCharging)) {
      _hasShownLowBatteryWarning = false;
    }
    
    return shouldShow;
  }

  void resetLowBatteryWarning() {
    _hasShownLowBatteryWarning = false;
  }

  @override
  void dispose() {
    _batteryBroadcastSubscription?.cancel();
    super.dispose();
  }
}