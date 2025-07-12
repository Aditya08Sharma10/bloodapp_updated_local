import 'package:flutter/material.dart';
import 'processing_page.dart';

void main() => runApp(BloodApp());

class BloodApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // You were missing this in your main app!
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            Image.asset(
              'assets/8.jpg',
              width: 430,
              height: 700,
              fit: BoxFit.fill,
            ),

            // Register button at the bottom of the image
            Positioned(
              bottom:70,
              child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProcessingPage()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 247, 1, 1), // bright red
    foregroundColor: Colors.white, // text color
    padding: EdgeInsets.symmetric(horizontal:45, vertical: 22),
    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20), // Try 30 to 50 for pill shape
),// pill-shaped
    elevation: 6, // shadow
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      letterSpacing: 1,
    ),
  ),
  child: Text('REGISTER'),
)

            ),
          ],
        ),
      ),
    );
  }
}
