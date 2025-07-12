import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'submitted.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyFormInImageApp());

class MyFormInImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/6.jpg',
                width: 430,
                height: 700,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 205,
                child: Container(
                  width: 320,
                  height: 400,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 177, 177).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: UserForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _mobile = TextEditingController();
  DateTime? _dob;
  String? _gender;
  String? _bloodGroup;
  Map<String, String>? _submittedData;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  void _submit() async {
  if (_formKey.currentState!.validate()) {
    final formattedDob = _dob != null ? DateFormat('yyyy-MM-dd').format(_dob!) : '';

    setState(() {
      _submittedData = {
        'Name': _name.text,
        'Email': _email.text,
        'Password': _password.text,
        'Mobile': _mobile.text,
        'DOB': formattedDob,
        'Gender': _gender ?? '',
        'Blood Group': _bloodGroup ?? '',
      };
    });

    // Call the submitData function
    await submitData(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      phone: _mobile.text,
      dob: formattedDob,
      gender: _gender ?? '',
      bloodGroup: _bloodGroup ?? '',
    );

    // Show the Snackbar only once
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Form submitted successfully!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 87, 1),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}


  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.pink.shade50,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Register',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 10),
        Theme(
          data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all<Color>(Colors.red),
              trackColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
              thickness: MaterialStateProperty.all<double>(6),
              radius: Radius.circular(6),
            ),
          ),
          child: Container(
            height: 180,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 8,
              radius: Radius.circular(4),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(right: 15.0),
                  primary: false,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        field(
                          controller: _name,
                          label: 'Name',
                          validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                        ),
                        field(
                          controller: _email,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                        ),
                        field(
                          controller: _password,
                          label: 'Password',
                          obscureText: true,
                          validator: (val) => val == null || val.length < 6 ? 'Min 6 characters' : null,
                        ),
                        field(
                          controller: _mobile,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.length != 10 ? 'Enter 10-digit number' : null,
                        ),
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: field(
                              controller: TextEditingController(
                                text: _dob == null
                                    ? ''
                                    : DateFormat('dd-MM-yyyy').format(_dob!),
                              ),
                              label: 'Date of Birth',
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Select date' : null,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                          ),
                          value: _gender,
                          items: ['Male', 'Female', 'Other']
                              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _gender = val;
                            });
                          },
                          validator: (val) => val == null ? 'Select gender' : null,
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                          ),
                          value: _bloodGroup,
                          items: _bloodGroups.map((String group) {
                            return DropdownMenuItem<String>(
                              value: group,
                              child: Text(group),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _bloodGroup = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Select blood group' : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text('Submit'),
        ),
        SizedBox(height: 8),
        if (_submittedData != null)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmittedDataPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 249, 231, 231),
              foregroundColor: const Color.fromARGB(255, 255, 0, 0),
            ),
            child: Text('View Submitted Data'),
          ),
      ],
    );
  }

  Widget field({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white70,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}

Future<void> submitData({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String dob,
  required String gender,
  required String bloodGroup,
}) async {
  const String url = 'http://10.124.247.27/bloodapp/submit_data.php'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'dob': dob,
        'gender': gender,
        'blood_group': bloodGroup,
      },
    );

    if (response.statusCode == 200) {
      if (response.body.trim() == 'success') {
        print('Data submitted successfully');
        // You can show a Snackbar or navigate to another page
      } else {
        print('Server error: ${response.body}');
      }
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
