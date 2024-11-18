import 'dart:io';
import 'package:fittrack/screens/heart_rate.dart';
import 'package:fittrack/screens/ip_address_screen.dart';
import 'package:fittrack/screens/quick_meditate_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Add ScrollView here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50), // To add some padding at the top if needed
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return const IPAddressScreen(isHeartrate: true,isPptPresenter: false,isStepCount: false);
                  }));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF363636), // Button color
                    fixedSize: Size(180, 60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monitor_heart,
                      color: Colors.white,
                      size: 20,
                    ), // Heart icon
                    SizedBox(width: 10), // Spacing between icon and text
                    Flexible(
                      child: Text(
                        'Heart Rate',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start, // Ensures text is center-aligned
                        maxLines: 2, // Allows text to wrap to the second line if needed
                        overflow: TextOverflow.visible, // Makes sure text wraps instead of truncating
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Add spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return const IPAddressScreen(isHeartrate: false,isStepCount: false,isPptPresenter: true,);
                  }));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF363636), // Button color
                    fixedSize: Size(180, 60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.computer_outlined,
                      color: Colors.white,
                      size: 25,
                    ), // Icon for SP02
                    SizedBox(width: 10), // Spacing between icon and text
                    Flexible(
                      child: Text(
                        'PPT Presenter',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start, // Ensures text is center-aligned
                        maxLines: 2, // Allows text to wrap to the second line if needed
                        overflow: TextOverflow.visible, // Makes sure text wraps instead of truncating
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Add padding at the bottom if needed
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return MeditationScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF363636), // Button color
                    fixedSize: Size(180, 60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 25,
                    ), // Icon for SP02
                    SizedBox(width: 10), // Spacing between icon and text
                    Flexible(
                      child: Text(
                        'Quick Meditate',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start, // Ensures text is center-aligned
                        maxLines: 2, // Allows text to wrap to the second line if needed
                        overflow: TextOverflow.visible, // Makes sure text wraps instead of truncating
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return const IPAddressScreen(isHeartrate: false,isPptPresenter: false,isStepCount: true,);
                  }));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF363636), // Button color
                    fixedSize: Size(180, 60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 25,
                    ), // Icon for SP02
                    SizedBox(width: 10), // Spacing between icon and text
                    Flexible(
                      child: Text(
                        'Step Count',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start, // Ensures text is center-aligned
                        maxLines: 2, // Allows text to wrap to the second line if needed
                        overflow: TextOverflow.visible, // Makes sure text wraps instead of truncating
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
