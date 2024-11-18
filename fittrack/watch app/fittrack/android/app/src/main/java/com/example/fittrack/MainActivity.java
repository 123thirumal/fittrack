package com.example.fittrack;

import android.os.Bundle;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements SensorEventListener {
    private static final String METHOD_CHANNEL = "com.example.fittrack/sensor";
    private static final String EVENT_CHANNEL = "com.example.fittrack/stepUpdates";
    private SensorManager sensorManager;
    private Sensor stepCounterSensor;
    private int stepCount = 0;
    private EventChannel.EventSink eventSink;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getStepCount")) {
                        result.success(stepCount);
                    } else {
                        result.notImplemented();
                    }
                });

        new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink = events;
                        sensorManager.registerListener(MainActivity.this, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        sensorManager.unregisterListener(MainActivity.this);
                        eventSink = null;
                    }
                });
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_STEP_COUNTER) {
            stepCount = (int) event.values[0];
            if (eventSink != null) {
                eventSink.success(stepCount);
            }
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Handle accuracy changes if necessary
    }
}
