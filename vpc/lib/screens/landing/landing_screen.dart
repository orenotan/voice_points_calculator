import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String Player1 = "8000";
  String Player2 = "8000";

  @override
  void initState() {
    super.initState();
    // Any initialization logic can go here
  }

  @override
  void dispose() {
    // Any cleanup logic can go here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Side (Takes up 50% of the screen)
          Expanded(
            child: Container(
              color: Colors.red.shade900, // Added color to easily see the split
              child: Center(
                child: Text(
                  Player1,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          
          // Right Side (Takes up the other 50% of the screen)
          Expanded(
            child: Container(
              color: Colors.green.shade800, // Added color to easily see the split
              child: Center(
                child: Text(
                  Player2,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}