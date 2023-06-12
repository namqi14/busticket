import 'package:flutter/material.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/services/tickets_service.dart';

class Records {
  final TicketService _ticketService = TicketService();

  Future<List<Tickets>> getPastRecords(int userID) async {
    return _ticketService.getBookings(userID);
  }
}
