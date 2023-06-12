import 'package:flutter/material.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/services/database_service.dart';

class UserListForm extends StatefulWidget {
  final int allowedUserID;

  const UserListForm({required this.allowedUserID});

  @override
  _UserListFormState createState() => _UserListFormState();
}

class _UserListFormState extends State<UserListForm> {
  List<Users> userList = [];
  int? currentUserID;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    getCurrentUserID().then((id) {
      setState(() {
        currentUserID = id;

        // Check if the allowedUserID matches the currentUserID
        if (widget.allowedUserID != currentUserID) {
          // Redirect the user or display an error message
          Navigator.of(context).pop(); // Redirect to the previous page
          // Alternatively, you can display an error message or show a different widget
        }
      });
    });
  }

  Future<int?> getCurrentUserID() async {
    String username = 'admin'; // Enter the current user's username
    String password = 'admin'; // Enter the current user's password
    DatabaseService databaseService = DatabaseService();
    return await databaseService.getCurrentUserID(username, password);
  }

  void fetchUsers() async {
    DatabaseService databaseService = DatabaseService();
    List<Users> users = await databaseService.getAllUsers();
    setState(() {
      userList = users;
    });
  }

  void removeUser(int? userID) async {
    if (userID != null) {
      DatabaseService databaseService = DatabaseService();
      bool success = await databaseService.removeUser(userID);
      if (success) {
        fetchUsers();
      } else {
        // Handle error while removing user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the allowedUserID matches the current user's ID
    if (widget.allowedUserID != currentUserID) {
      // Display an error message or redirect the user
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Text('You do not have access to this page.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (BuildContext context, int index) {
          Users user = userList[index];
          return ListTile(
            title: Text(user.fullName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${user.username}'),
                Text('UserID: ${user.userID}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => removeUser(user.userID),
            ),
          );
        },
      ),
    );
  }
}
