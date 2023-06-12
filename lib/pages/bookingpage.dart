import 'package:flutter/material.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/pages/confirmationpage.dart';
import 'package:busticket/services/tickets_service.dart';
import 'package:busticket/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingPage extends StatefulWidget {
  final Users users;

  BookingPage({required this.users});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TicketService _ticketService = TicketService();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _departureStation;
  late String _destinationStation;
  late String _firstName;
  late String _lastName;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _departureStation = 'KL Sentral';
    _destinationStation = 'KL Sentral';
    _firstName = '';
    _lastName = '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Users loggedInUser = widget.users;
      loggedInUser.firstName = _firstName;
      loggedInUser.lastName = _lastName;

      var dbService = DatabaseService();
      bool result = await dbService.updateUsers(loggedInUser);
      if (!result) {
        print("Failed to update users' first name and last name.");
      }

      int generatedID = _ticketService.generateTicketsID();
      Tickets newTickets = Tickets(
        ticketsID: generatedID,
        departDate: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        time: _selectedTime.format(context), // Use the selected time
        departStation: _departureStation,
        destStation: _destinationStation,
        userID: loggedInUser.userID!,
      );

      await _ticketService.saveTicket(newTickets);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            tickets: newTickets,
            users: loggedInUser,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departure Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.calendarAlt, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Departure Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.clock, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${_selectedTime.format(context)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Departure Station',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _departureStation,
                  onChanged: (value) {
                    setState(() {
                      _departureStation = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'KL Sentral',
                      child: Text('KL Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'Johor Bahru Sentral',
                      child: Text('Johor Bahru Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'Kota Bahru Bus Terminal',
                      child: Text('Kota Bahru Terminal'),
                    ),
                    DropdownMenuItem(
                      value: 'Alor Setar Terminal',
                      child: Text('Alor Setar Terminal'),
                    ),
                    DropdownMenuItem(
                      value: 'Melaka Sentral',
                      child: Text('Melaka Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'TBS',
                      child: Text('TBS'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Departure Station',
                    prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Destination Station',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _destinationStation,
                  onChanged: (value) {
                    setState(() {
                      _destinationStation = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'KL Sentral',
                      child: Text('KL Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'Johor Bahru Sentral',
                      child: Text('Johor Bahru Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'Kota Bahru Terminal',
                      child: Text('Kota Bahru Terminal'),
                    ),
                    DropdownMenuItem(
                      value: 'Alor Setar Terminal',
                      child: Text('Alor Setar Terminal'),
                    ),
                    DropdownMenuItem(
                      value: 'Melaka Sentral',
                      child: Text('Melaka Sentral'),
                    ),
                    DropdownMenuItem(
                      value: 'TBS',
                      child: Text('TBS'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Destination Station',
                    prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _lastName = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Book Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
