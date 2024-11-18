import 'dart:convert'; // To convert the map into a JSON string
import 'dart:io'; // For Socket
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepCountService {
  static const methodChannel = MethodChannel('com.example.fittrack/sensor');
  static const eventChannel = EventChannel('com.example.fittrack/stepUpdates');

  // Single call to get the current step count (already in use)
  Future<int> getStepCount() async {
    try {
      final int stepCount = await methodChannel.invokeMethod('getStepCount');
      return stepCount;
    } on PlatformException catch (e) {
      print("Failed to get step count: '${e.message}'");
      return 0;
    }
  }

  // Stream for continuous step updates
  Stream<int> stepCountStream() {
    return eventChannel.receiveBroadcastStream().map((dynamic event) => event as int);
  }
}

class StepCountScreen extends StatefulWidget {
  final Socket socket;
  const StepCountScreen({super.key, required this.socket});

  @override
  _StepCountScreenState createState() => _StepCountScreenState();
}

class _StepCountScreenState extends State<StepCountScreen> {
  StepCountService stepCountService = StepCountService();
  int _stepCount = 0;

  @override
  void initState() {
    super.initState();
    _listenForStepCountUpdates();
  }

  void _listenForStepCountUpdates() {
    stepCountService.stepCountStream().listen((int newStepCount) {
      setState(() {
        _stepCount = newStepCount;
      });
    });
  }

  void _sendStepCountData() {
    // Get current date in 'yyyy-MM-dd' format
    String currentDate = DateTime.now().toString().split(' ')[0];

    // Create the data in the desired format
    Map<String, dynamic> stepCountData = {
      'day': currentDate,
      'StepCount': _stepCount
    };

    // Convert the map to a JSON string
    String dataToSend = jsonEncode(stepCountData);

    // Send the data through the socket
    widget.socket.write('$dataToSend\n');
    print("Sent: $dataToSend");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text('Step Count: $_stepCount',
                  style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _sendStepCountData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF), // Button color
                maximumSize: const Size(100, 40),
              ),
              child: const Icon(Icons.connected_tv_sharp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
