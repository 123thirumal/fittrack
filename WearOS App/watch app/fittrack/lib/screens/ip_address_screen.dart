import 'package:fittrack/screens/heart_rate.dart';
import 'package:fittrack/screens/home_screen.dart';
import 'package:fittrack/screens/ppt_presenter_screen.dart';
import 'package:fittrack/screens/step_count_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IPAddressScreen extends StatefulWidget {
  const IPAddressScreen({super.key,required this.isHeartrate,required this.isPptPresenter,required this.isStepCount});
  final bool isHeartrate;
  final bool isPptPresenter;
  final bool isStepCount;

  @override
  _IPAddressScreenState createState() => _IPAddressScreenState();
}

class _IPAddressScreenState extends State<IPAddressScreen> {
  bool isConnecting = false;
  bool connected=false;
  Socket? socket;
  // Create TextEditingControllers for each text field
  final TextEditingController ip1 = TextEditingController();
  final TextEditingController ip2 = TextEditingController();
  final TextEditingController ip3 = TextEditingController();
  final TextEditingController ip4 = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the tree
    ip1.dispose();
    ip2.dispose();
    ip3.dispose();
    ip4.dispose();
    super.dispose();
  }

  Future<void> connectToServer(String ipAddress) async {
    try {
      setState(() {
        isConnecting=true;
      });
      // Attempting to connect to the server
      socket = await Socket.connect(ipAddress, 1010);
      setState(() {
        isConnecting=false;
        connected=true;
      });
      print(
          'Connected to: ${socket!.remoteAddress.address}:${socket!.remotePort}');


    } catch (e) {
      setState(() {
        isConnecting=false;
      });
      print('Error connecting to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set a background color
      body: (isConnecting)
          ? const SpinKitWave(
              color: Colors.white,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter IP address',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First TextField
                    Container(
                      width: 40, // Set width for the TextField
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: ip1,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: '0',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Second TextField
                    Container(
                      width: 40, // Set width for the TextField
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: ip2,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: '0',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Third TextField
                    Container(
                      width: 40, // Set width for the TextField
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: ip3,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: '0',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Fourth TextField
                    Container(
                      width: 40, // Set width for the TextField
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: ip4,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: '0',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      // Optionally, you can access the text from the controllers here
                      String ipAddress =
                          "${ip1.text}.${ip2.text}.${ip3.text}.${ip4.text}";
                      print(
                          'IP Address: $ipAddress'); // Print or handle the IP address as needed
                      // Navigate to another screen or perform an action
                      connectToServer(ipAddress);
                      if(connected){
                        if(widget.isHeartrate){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx){
                            return HeartRateScreen(socket: socket!,);
                          }));
                        }
                        else if(widget.isPptPresenter){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx){
                            return PptPresenterScreen(socket: socket!,);
                          }));
                        }
                        else if(widget.isStepCount){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx){
                            return StepCountScreen(socket: socket!,);
                          }));
                        }
                      }
                    },
                    child: Text('Connect',
                        style: TextStyle(fontSize: 20, color: Colors.black))),
              ],
            ),
    );
  }
}
