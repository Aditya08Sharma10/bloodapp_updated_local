import 'package:flutter/material.dart';
import 'form_page.dart'; // replace this with the correct path if needed

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});
  @override
  ProcessingPageState createState() => ProcessingPageState();
}

class ProcessingPageState extends State<ProcessingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyFormInImageApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 1, 1),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered image
            Image.asset(
              'assets/2.png', // Replace with your image path
              width: 430,
              height: 730,
              fit: BoxFit.fill,
            ),

            // Text over the image
           
          ],
        ),
      ),
    );
  }
}
