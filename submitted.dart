import 'package:bloodapp/main.dart';
import 'main.dart'; // Make sure this is your actual home page file
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubmittedDataPage extends StatefulWidget {
  @override
  _SubmittedDataPageState createState() => _SubmittedDataPageState();
}

class _SubmittedDataPageState extends State<SubmittedDataPage> {
  List<dynamic> submittedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmittedData();
  }

  Future<void> fetchSubmittedData() async {
    final url = Uri.parse('http://10.124.247.27/bloodapp/get_data.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            submittedData = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          print("Server error: ${jsonResponse['message']}");
          setState(() => isLoading = false);
        }
      } else {
        print("Failed to fetch: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Exception: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/10.jpg',
              width: 430,
              height: 700,
              fit: BoxFit.fill,
            ),
            Container(
              width: 320,
              height: 480,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : submittedData.isEmpty
                  ? Center(child: Text("No submissions found!"))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: submittedData.length,
                      itemBuilder: (context, index) {
                        final item = submittedData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${item['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Email: ${item['email']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Phone: ${item['phone']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'DOB: ${item['dob']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Gender: ${item['gender']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Blood Group: ${item['blood_group']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Divider(color: Colors.black),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
