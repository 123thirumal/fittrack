import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

class FilteredHeartRateData {
  final String heartRate;
  final String time;

  FilteredHeartRateData({required this.heartRate, required this.time});
}

class HeartRateScreen extends StatefulWidget {

  const HeartRateScreen({super.key,required this.socket});

  final Socket socket;
  @override
  _HeartRateScreenState createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  List<HealthDataPoint> healthDataList = [
    HealthDataPoint(
        uuid: "123e4567-e89b-12d3-a456-426614174000",
        value:
            NumericHealthValue(numericValue: 72), // Simulated heart rate value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(minutes: 5)),
        dateTo: DateTime.now().subtract(Duration(minutes: 5)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-1",
        sourceId: "source-1",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174001",
        value: NumericHealthValue(numericValue: 85), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174002",
        value: NumericHealthValue(numericValue: 80), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174003",
        value: NumericHealthValue(numericValue: 89), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174004",
        value: NumericHealthValue(numericValue: 92), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174005",
        value: NumericHealthValue(numericValue: 76), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
    HealthDataPoint(
        uuid: "223e4567-e89b-12d3-a456-426614174006",
        value: NumericHealthValue(numericValue: 78), // Another sample value
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: DateTime.now().subtract(Duration(hours: 1)),
        dateTo: DateTime.now().subtract(Duration(hours: 1)),
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: "device-2",
        sourceId: "source-2",
        sourceName: "Mock Data",
        recordingMethod: RecordingMethod.unknown,
        metadata: {"note": "Sample data"}),
  ];

  Future<void> fetchHeartRate() async {
    // Define the types of data you want to read
    final types = [HealthDataType.HEART_RATE];

    try {
      // Check if Health Connect is available
      bool isHealthConnectAvailable = await Health().isHealthConnectAvailable();

      // Prompt to install Health Connect if it's not available
      if (!isHealthConnectAvailable) {
        await Health().installHealthConnect();
        print("Health Connect installed");
      }

      // Request permissions to access health data
      bool requested = await Health().requestAuthorization(types);

      if (requested) {
        // Get the data from the last 7 days
        List<HealthDataPoint> newHealthDataList =
            await Health().getHealthDataFromTypes(
          startTime: DateTime.now().subtract(Duration(days: 7)),
          endTime: DateTime.now(),
          types: types,
        );

        // Append new data to the existing health data list
        healthDataList.addAll(newHealthDataList);
        setState(() {}); // Refresh the UI
      } else {
        print("Permission not granted");
      }
    } catch (e) {
      print("Error fetching heart rate data: $e");
    }
  }


  void sendingToServer() {
    List<FilteredHeartRateData> filteredDataList = [];

    for (var dataPoint in healthDataList) {
      String temp = dataPoint.value.toString();
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(temp);
      String heartRate = match != null ? match.group(0)! : 'N/A';
      String formattedDate = DateFormat('HH:mm').format(dataPoint.dateFrom);

      filteredDataList.add(FilteredHeartRateData(heartRate: heartRate, time: formattedDate));
    }

    // Convert filteredDataList to JSON
    String jsonString = jsonEncode(filteredDataList.map((data) => {
      'heartRate': data.heartRate,
      'time': data.time,
    }).toList());

    try {
      // Send the JSON string through the socket
      widget.socket.write('$jsonString\n');
      // Optionally, you can display a success message
      print("Data sent successfully: $jsonString");
    } catch (e) {
      // Handle any exceptions that occur during sending
      print("Error sending data: $e");
      // Notify the user about the error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHeartRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
              MainAxisAlignment.center, // Centering the Column content
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: healthDataList.length,
                itemBuilder: (context, index) {
                  final dataPoint = healthDataList[index];
                  String temp = dataPoint.value.toString();
                  RegExp regExp = RegExp(r'\d+');
                  Match? match = regExp.firstMatch(temp);
                  String heartrate = match != null ? match.group(0)! : 'N/A';

                  return ListTile(
                    title: Center(
                        child: Text('Heart Rate: $heartrate BPM',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15))),
                    subtitle: Center(
                        child: Text(
                            'Time: ${DateFormat('HH:mm').format(dataPoint.dateFrom)}',
                            style: TextStyle(color: Colors.white))),
                  );
                },
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                sendingToServer();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF), // Button color
                  maximumSize: const Size(100,40)
              ),
              child: const Icon(Icons.connected_tv_sharp,color: Colors.black,)
            ),
          ],
        ),
      ),
    );
  }
}
