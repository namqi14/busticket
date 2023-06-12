import 'package:flutter/material.dart';
import 'package:busticket/pages/loginpage.dart';
import 'package:busticket/services/authentication_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String _mobileNumber = '';
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<void> _showErrorSnackbar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showRegistrationSuccessfulDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Congratulations! Your registration was successful.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(
                    FontAwesomeIcons.user,
                    size: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(29.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 173, 183, 216),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(29.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 173, 183, 216),
                ),
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    size: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(29.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 173, 183, 216),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(
                    FontAwesomeIcons.phone,
                    size: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(29.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 173, 183, 216),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobileNumber = value!;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print(
                        'Registering user: $_username, $_password, $_mobileNumber');
                    try {
                      bool result = await _authenticationService.registerUser(
                        _username,
                        _password,
                        _mobileNumber,
                      );
                      if (result) {
                        _showRegistrationSuccessfulDialog();
                      } else {
                        throw Exception("Registration failed.");
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
