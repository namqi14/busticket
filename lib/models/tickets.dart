import 'package:flutter/material.dart';

class Tickets {
  int? ticketsID;
  DateTime? departDate;
  String time; // Update the type to String
  String? departStation;
  String? destStation;
  int? userID;

  Tickets({
    this.ticketsID,
    this.departDate,
    required this.time, // Make the field required
    this.departStation,
    this.destStation,
    this.userID,
  });

  Map<String, dynamic> toMapWithDateTimeToString() {
    var map = <String, dynamic>{
      'book_ID': ticketsID,
      'time': time,
      'depart_station': departStation,
      'dest_station': destStation,
      'user_id': userID,
    };

    if (departDate != null) {
      map['depart_date'] = departDate!.toIso8601String();
    }

    return map;
  }

  static Tickets fromMap(Map<String, dynamic> map) {
    return Tickets(
      ticketsID: map['book_ID'] ?? 0,
      departDate: map['depart_date'] != null
          ? DateTime.parse(map['depart_date'])
          : null,
      time: map['time'] ?? '',
      departStation: map['depart_station'] ?? '',
      destStation: map['dest_station'] ?? '',
      userID: map['user_id'] ?? 0,
    );
  }
}
