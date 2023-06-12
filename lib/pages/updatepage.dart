import 'package:flutter/material.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/services/tickets_service.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateTicketPage extends StatefulWidget {
  final Tickets tickets;
  final Users users;

  UpdateTicketPage({required this.tickets, required this.users});

  @override
  _UpdateTicketPageState createState() => _UpdateTicketPageState();
}

class _UpdateTicketPageState extends State<UpdateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  late Tickets _tickets;
  late Users _users;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TicketService _ticketService = TicketService();

  @override
  void initState() {
    super.initState();
    _tickets = widget.tickets;
    _users = widget.users;
    _selectedDate = _tickets.departDate!;
    _selectedTime = parseTimeString(_tickets.time!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TimeOfDay parseTimeString(String timeString) {
    final format = DateFormat.Hm();
    final dt = format.parse(timeString);
    return TimeOfDay.fromDateTime(dt);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateTickets() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _tickets.departDate = _selectedDate;
      _tickets.time = _selectedTime.format(context);

      await _ticketService.updateBooking(_tickets);

      Navigator.of(context).pop(_tickets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Ticket'),
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
                      Icon(FontAwesomeIcons.calendarAlt),
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
                      Icon(FontAwesomeIcons.clock),
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
                        initialValue: _users.firstName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                          prefixIcon: Icon(FontAwesomeIcons.user),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _users.firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _users.lastName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                          prefixIcon: Icon(FontAwesomeIcons.user),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _users.lastName = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateTickets,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
