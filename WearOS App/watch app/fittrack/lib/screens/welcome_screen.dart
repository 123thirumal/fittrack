import 'package:fittrack/screens/home_screen.dart';
import 'package:fittrack/screens/ip_address_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello, Thirumal',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return HomeScreen();
                  }));
                },
                child: Text('Start',
                    style: TextStyle(fontSize: 20, color: Colors.black))),
          ],
        ),
      ),
    );
  }
}
