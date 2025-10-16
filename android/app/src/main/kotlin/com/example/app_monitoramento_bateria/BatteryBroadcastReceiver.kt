package com.example.app_monitoramento_bateria

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.plugin.common.EventChannel

class BatteryBroadcastReceiver : BroadcastReceiver(), EventChannel.StreamHandler {
    
    private var eventSink: EventChannel.EventSink? = null
    private var context: Context? = null

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BATTERY_CHANGED) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            
            val batteryPct = level * 100 / scale.toFloat()
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || 
                           status == BatteryManager.BATTERY_STATUS_FULL
            
            val batteryInfo = mapOf(
                "level" to batteryPct.toInt(),
                "isCharging" to isCharging,
                "status" to status
            )
            
            eventSink?.success(batteryInfo)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        context?.let { ctx ->
            val filter = IntentFilter().apply {
                addAction(Intent.ACTION_BATTERY_CHANGED)
                addAction(Intent.ACTION_BATTERY_LOW)
                addAction(Intent.ACTION_BATTERY_OKAY)
                addAction(Intent.ACTION_POWER_CONNECTED)
                addAction(Intent.ACTION_POWER_DISCONNECTED)
            }
            ctx.registerReceiver(this, filter)
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        context?.unregisterReceiver(this)
    }

    fun setContext(ctx: Context) {
        context = ctx
    }
}