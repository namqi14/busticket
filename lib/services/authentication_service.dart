import 'package:flutter/material.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/services/database_service.dart';

class AuthenticationService {
  final DatabaseService _dbService = DatabaseService();

  Future<bool> registerUser(
      String username, String password, String mobileNumber) async {
    // add mobileNumber parameter
    // Create a new User object with mobile number
    Users newUser = Users(
      username: username,
      password: password,
      mobileHp: mobileNumber,
    );

    print('New user: $newUser');

    // Save the user to the database
    bool result = await _dbService.insertUser(newUser);

    return result;
  }

  Future<Users?> loginUser(String username, String password) async {
    // Attempt to retrieve the user from the database
    Users? user = await _dbService.getUsers(username, password);

    // If the user exists and the passwords match, return the user
    if (user != null && user.password == password) {
      return user;
    }

    // If the user doesn't exist or the passwords don't match, return null
    return null;
  }

  Future<void> logoutUser(BuildContext context) async {
    // Clear the user session or perform any necessary logout operations
    // For example, you can delete any stored user data or tokens

    // Navigate to the login screen and reset any relevant state
    Navigator.pushReplacementNamed(context, '/');
  }
}
