import 'package:flutter/material.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/models/records.dart';
import 'package:busticket/pages/loginpage.dart';
import 'package:busticket/pages/user_list_form.dart';

class ProfilePage extends StatefulWidget {
  final Users users;

  ProfilePage({required this.users});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Records _records = Records();
  List<Tickets> _pastRecords = [];

  @override
  void initState() {
    super.initState();
    _loadPastRecords();
  }

  Future<void> _loadPastRecords() async {
    final userID = widget.users.userID ?? 0;
    try {
      final pastRecords = await _records.getPastRecords(userID);
      setState(() {
        _pastRecords = pastRecords;
      });
    } catch (e) {
      // Keep the existing records and update the UI accordingly
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigateToUserList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserListForm(allowedUserID: widget.users.userID ?? 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _navigateToUserList,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile information...
            CircleAvatar(
              radius: 50,
              // Display default profile icon
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Full Name: ${widget.users.fullName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone: ${widget.users.mobileHp}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            Text(
              'Past Records:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _pastRecords.length,
                itemBuilder: (context, index) {
                  final ticket = _pastRecords[index];
                  return ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text('Booking ID: ${ticket.ticketsID}'),
                    subtitle: Text('Departure: ${ticket.departStation}'),
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
