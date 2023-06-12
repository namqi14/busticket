import 'package:flutter/material.dart';
import 'package:busticket/pages/homepage.dart';
import 'package:busticket/pages/loginpage.dart';
import 'package:busticket/pages/registerpage.dart';
import 'package:busticket/pages/bookingpage.dart';
import 'package:busticket/pages/user_list_form.dart';
import 'package:busticket/models/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BluDotBus',
      theme: ThemeData(
          primarySwatch: createMaterialColor(Color.fromARGB(255, 33, 47, 87)),
          scaffoldBackgroundColor: Color.fromARGB(255, 248, 247, 247)),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) =>
            HomePage(users: Users(username: '', password: '')),
        '/userList': (context) => UserListForm(allowedUserID: int.parse('1')),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/booking') {
          final Users user = settings.arguments as Users;
          return MaterialPageRoute(
            builder: (context) {
              return BookingPage(users: user);
            },
          );
        }
        assert(false, 'Invalid route: ${settings.name}');
        throw Exception('Invalid route: ${settings.name}');
      },
    );
  }
}
