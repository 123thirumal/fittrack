import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final int totalTimeInMinutes;
  final Socket socket;

  const TimerScreen({super.key,required this.totalTimeInMinutes,required this.socket});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int totalTimeInSeconds;
  late int timeElapsed;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    totalTimeInSeconds = widget.totalTimeInMinutes * 60; // Convert minutes to seconds
    timeElapsed = 0;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeElapsed < totalTimeInSeconds) {
          timeElapsed++;
        } else {
          timer.cancel(); // Stop timer if the time is up
        }
      });
    });
  }

  void sendMessageToServer(String message) {
    try {
      widget.socket.write('$message\n'); // Try to send the message to the server
      print('Message sent: $message');
    } catch (e) {
      print('Error sending message to server: $e');
      // Optionally, you can show an alert or notification to the user
    }
  }


  @override
  void dispose() {
    timer.cancel(); // Cancel timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress for circular progress indicator
    double progress = timeElapsed / totalTimeInSeconds;
    int timeRemaining = totalTimeInSeconds - timeElapsed;
    String formattedTime = formatTime(timeRemaining);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.black, // Background of progress indicator
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Progress color
              ),
            ),
            // Display running time in the center of the circular progress
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          // Handle back action (subtract time or navigate back)
                          sendMessageToServer("Back");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,)
                    ),
                    SizedBox(width: 20), // Space between the two buttons
                    ElevatedButton(
                        onPressed: () {
                          // Handle front action (add time or navigate forward)
                          sendMessageToServer("Next");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,)
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to format time in MM:SS format
  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
