import 'dart:io';
import 'package:fittrack/screens/timer_screen.dart';
import 'package:flutter/material.dart';

class PptPresenterScreen extends StatefulWidget {

  const PptPresenterScreen({super.key,required this.socket});

  final Socket socket;
  @override
  _PptPresenterScreenState createState() => _PptPresenterScreenState();
}

class _PptPresenterScreenState extends State<PptPresenterScreen> {

  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Presentation Time',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 15), // Spacing between the label and text field

          // Add TextField for input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: timeController,
              keyboardType: TextInputType.number, // Allow number input
              style: TextStyle(color: Colors.white), // Text color
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // White underline when not focused
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Blue underline when focused
                ),
                hintText: 'Enter time in minutes',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                fillColor: Colors.transparent, // Remove fill color if no box is needed
                filled: false, // Ensure it doesn't fill the background
              ),
            ),
          ),


          SizedBox(height: 15),

          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(totalTimeInMinutes: int.parse(timeController.text),socket: widget.socket,),
                  ),
                );
              },
              child: Text('Start',
                  style: TextStyle(fontSize: 20, color: Colors.black))),
        ],
      ),
    );
  }
}