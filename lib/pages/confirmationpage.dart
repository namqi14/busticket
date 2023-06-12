import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/pages/updatepage.dart';
import 'package:busticket/pages/homepage.dart';
import 'package:busticket/services/tickets_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ConfirmationPage extends StatefulWidget {
  late Tickets tickets;
  late Users users;

  ConfirmationPage({required this.tickets, required this.users});

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final TicketService _ticketService = TicketService();

  void _confirmBooking() {
    print('Ticket ID: ${widget.tickets.ticketsID}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking Confirmed!'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(users: widget.users),
      ),
    );
  }

  void _updateBooking() async {
    final updatedTickets = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTicketPage(
          tickets: widget.tickets,
          users: widget.users,
        ),
      ),
    );

    if (updatedTickets != null) {
      setState(() {
        widget.tickets = updatedTickets;
      });
    }
  }

  void _cancelBooking() {
    _ticketService.cancelBooking(widget.tickets.ticketsID ?? 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking Cancelled!'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                users: widget.users,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Confirm your booking',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Ticket Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.idCard),
                title: Text('Ticket ID'),
                subtitle: Text('${widget.tickets.ticketsID ?? "N/A"}'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.mapMarkerAlt),
                title: Text('Departure Station'),
                subtitle: Text('${widget.tickets.departStation ?? "N/A"}'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.mapMarkerAlt),
                title: Text('Destination Station'),
                subtitle: Text('${widget.tickets.destStation ?? "N/A"}'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.calendarAlt),
                title: Text('Departure Date'),
                subtitle: Text(widget.tickets.departDate != null
                    ? DateFormat.yMMMd().format(widget.tickets.departDate!)
                    : 'N/A'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.clock),
                title: Text('Departure Time'),
                subtitle: Text('${widget.tickets.time}'),
              ),
              SizedBox(height: 20),
              Text(
                'User Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.user),
                title: Text('Name'),
                subtitle:
                    Text('${widget.users.firstName} ${widget.users.lastName}'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.phone),
                title: Text('Phone'),
                subtitle: Text('${widget.users.mobileHp}'),
              ),
              SizedBox(height: 20),
              Container(
                height: 150, // Adjust this height as needed
                child: Center(
                  child: SfBarcodeGenerator(
                    value: widget.tickets.ticketsID.toString(),
                    symbology: Code128(),
                    showValue: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmBooking,
                child: Text('Confirm Booking'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _cancelBooking,
                child: Text('Cancel Booking'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateBooking,
                child: Text('Update Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
