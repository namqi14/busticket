import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:busticket/services/tickets_service.dart';
import 'package:busticket/services/authentication_service.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/models/users.dart';
import 'package:busticket/pages/confirmationpage.dart';
import 'package:busticket/pages/updatepage.dart';
import 'package:busticket/pages/profilepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final Users users;

  HomePage({required this.users});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TicketService _ticketService = TicketService();
  Future<List<Tickets>>? _ticketsFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _ticketService.getBookings(widget.users.userID ?? 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ticketsFuture = _ticketService.getBookings(widget.users.userID ?? 0);
  }

  Future<void> _deleteTickets(int? ticketsID) async {
    if (ticketsID != null) {
      await _ticketService.cancelBooking(ticketsID);
      setState(() {
        _ticketsFuture = _ticketService.getBookings(widget.users.userID ?? 0);
      });
    }
  }

  void _logoutUsers(BuildContext context) {
    AuthenticationService authenticationService = AuthenticationService();
    authenticationService.logoutUser(context);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
    ));

    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/booking', arguments: widget.users)
              .then((_) {
            setState(() {
              _ticketsFuture =
                  _ticketService.getBookings(widget.users.userID ?? 0);
            });
          });
        },
        elevation: 10.0,
        label: const Text('Book Here!'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildProfilePage();
      default:
        return Container();
    }
  }

  Widget _buildHomePage() {
    return FutureBuilder<List<Tickets>>(
      future: _ticketsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.white,
                    child: Image.asset(
                      'lib/assets/busLogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => _logoutUsers(context),
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) {
                      Tickets ticket = snapshot.data![index];
                      print('Ticket ID: ${ticket.ticketsID}');
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Material(
                            elevation: 7.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Stack(
                              children: [
                                Card(
                                  margin: EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmationPage(
                                            tickets: ticket,
                                            users: widget.users,
                                          ),
                                        ),
                                      ).then((updatedTickets) {
                                        if (updatedTickets != null) {
                                          setState(() {
                                            ticket = updatedTickets;
                                          });
                                        }
                                      });
                                    },
                                    child: ListTile(
                                      title: Text(
                                        'Ticket #${ticket.ticketsID != null ? ticket.ticketsID.toString() : "default"}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${ticket.departStation ?? "default"} to ${ticket.destStation ?? "default"}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          Text(
                                            '${DateFormat.yMMMd().format(ticket.departDate ?? DateTime.now())} ${ticket.time ?? "default"}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateTicketPage(
                                                tickets: ticket,
                                                users: widget.users,
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {
                                              _ticketsFuture =
                                                  _ticketService.getBookings(
                                                      widget.users.userID ?? 0);
                                            });
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _deleteTickets(ticket.ticketsID),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProfilePage() {
    return ProfilePage(users: widget.users);
  }
}
