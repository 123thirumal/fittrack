import 'dart:async';
import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  double _progress = 0.0;
  int _timeInSeconds = 300; // Default time: 5 minutes (300 seconds)
  Timer? _timer;
  bool _timerEnded = false;
  bool _isPlaying = false; // Track if the timer is running (playing) or paused

  int _selectedTime = 5; // Dropdown default selection (5 minutes)

  // Time options for dropdown in minutes
  final List<int> _timeOptions = [5, 10, 15, 20];

  void _startPauseTimer() {
    // Toggle the play/pause state
    if (_isPlaying) {
      _pauseTimer();
    } else {
      _startOrResumeTimer();
    }
  }

  void _startOrResumeTimer() {
    setState(() {
      _isPlaying = true; // Timer is running (playing)
      _timerEnded = false;
    });

    _timer?.cancel(); // Cancel any existing timer before starting a new one

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeInSeconds > 0) {
          _timeInSeconds--;
          _progress = ((_selectedTime * 60) - _timeInSeconds) / (_selectedTime * 60);
        } else {
          _timerEnded = true;
          _isPlaying = false; // Set to paused when timer ends
          _timer?.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPlaying = false; // Timer is paused
    });
    _timer?.cancel(); // Stop the timer but retain the time state
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _timerEnded
            ? Text(
          'Relax and breathe...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.grey[600],
                  ),
                ),
                Text(
                  '${(_timeInSeconds / 60).floor().toString().padLeft(2, '0')} : ${(_timeInSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dropdown for time selection
                DropdownButton<int>(
                  dropdownColor: Colors.black, // Dropdown background
                  value: _selectedTime,
                  items: _timeOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        '$value min',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (!_isPlaying) {
                      // Allow changing time only if the timer is not running
                      setState(() {
                        _selectedTime = newValue ?? 5; // Default to 5 if null
                        _timeInSeconds = _selectedTime * 60; // Update time in seconds
                        _progress = 0.0; // Reset the progress
                      });
                    }
                  },
                  underline: Container(
                    height: 2,
                    color: Colors.white, // Underline color
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    shape: CircleBorder(),
                  ),
                  onPressed: _startPauseTimer,
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow, // Icon changes between play and pause
                    color: Colors.black, // Icon color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
