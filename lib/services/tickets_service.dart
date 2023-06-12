import 'package:sqflite/sqflite.dart';
import 'package:busticket/models/tickets.dart';
import 'package:busticket/services/database_service.dart';
import 'dart:math';

class TicketService {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Tickets>> getBookings(int userID) async {
    final db = await _dbService.db;
    final List<Map<String, dynamic>> result = await db!.query(
      'busticket',
      where: 'user_id = ?',
      whereArgs: [userID],
      orderBy: 'book_ID DESC',
    );
    return result.map((map) => Tickets.fromMap(map)).toList();
  }

  Future<void> saveTicket(Tickets tickets) async {
    final db = await _dbService.db;
    final generatedID = generateTicketsID();
    tickets.ticketsID = generatedID;
    await db!.insert('busticket', tickets.toMapWithDateTimeToString());
  }

  Future<void> updateBooking(Tickets tickets) async {
    final db = await _dbService.db;
    await db!.update('busticket', tickets.toMapWithDateTimeToString(),
        where: 'book_ID = ?', whereArgs: [tickets.ticketsID]);
  }

  Future<void> confirmBooking(int ticketsID) async {
    // In our current design, a ticket becomes 'confirmed' when it's saved in the database.
    // So this method might not be needed. Alternatively, you might update some status field here.
  }

  Future<void> cancelBooking(int ticketsID) async {
    final db = await _dbService.db;
    // We're assuming that 'cancelling' a ticket means removing it from the database.
    await db!.delete('busticket', where: 'book_ID = ?', whereArgs: [ticketsID]);
  }

  int generateTicketsID() {
    var rng = new Random();
    return rng.nextInt(900000) +
        100000; // generates a random number between 100000 and 999999
  }

  // In TicketService
  Future<Tickets> getLatestBooking(int userID) async {
    final db = await _dbService.db;
    final List<Map<String, dynamic>> result = await db!.query(
      'busticket',
      where: 'user_id = ?',
      whereArgs: [userID],
      orderBy: 'book_ID DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Tickets.fromMap(result.first);
    }
    throw Exception("No ticket found");
  }
}
