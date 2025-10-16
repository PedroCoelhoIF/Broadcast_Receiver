package com.example.app_monitoramento_bateria

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val BATTERY_CHANNEL = "com.example.battery_monitor/battery"
    private lateinit var batteryReceiver: BatteryBroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Configura o EventChannel para o Broadcast Receiver
        batteryReceiver = BatteryBroadcastReceiver()
        batteryReceiver.setContext(this)
        
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)
            .setStreamHandler(batteryReceiver)
    }

    override fun onDestroy() {
        super.onDestroy()
        // Limpa o receiver quando a activity é destruída
        try {
            unregisterReceiver(batteryReceiver)
        } catch (e: IllegalArgumentException) {
            // Receiver já foi desregistrado
        }
    }
}