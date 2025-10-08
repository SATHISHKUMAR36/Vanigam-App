import 'package:flutter/material.dart';


enum UserRole {
  agent,
  superuser,
  subagent
}

class ThemeProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.agent;

  UserRole get currentRole => _currentRole;

  ThemeData get currentTheme {
    switch (_currentRole) {
      case UserRole.agent:
        return ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          // scaffoldBackgroundColor: Colors.grey[200],
        useMaterial3:false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        brightness: Brightness.light,
        primaryColor:  Colors.indigo[500],
        canvasColor:Colors.white,
        fontFamily: 'Source Sans Pro',
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
        textTheme: const TextTheme(
            titleMedium: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            titleSmall: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            displayLarge: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                fontSize: 14.0,
                color: Color(0XFF171b34),
                fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 16.0, color: Colors.black),
            headlineMedium: TextStyle(fontSize: 14.0, color: Colors.black),
            headlineSmall: TextStyle(fontSize: 12.0, color: Colors.black),
            titleLarge: TextStyle(
                fontSize: 20.0, color: Color.fromARGB(255, 8, 83, 180)),
            bodySmall: TextStyle(fontSize: 14, color: Colors.grey)),
        );
      case UserRole.superuser:
        return ThemeData(
          useMaterial3:false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        brightness: Brightness.light,
         scaffoldBackgroundColor: Colors.grey[200],
        // splashColor: Colors.pink,
        primaryColor:  const Color.fromARGB(255, 26, 68, 145),
        canvasColor:Colors.white,
        fontFamily: 'Source Sans Pro',
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
        textTheme: const TextTheme(
            titleMedium: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            titleSmall: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            displayLarge: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                fontSize: 14.0,
                color: Color(0XFF171b34),
                fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 16.0, color: Colors.black),
            headlineMedium: TextStyle(fontSize: 14.0, color: Colors.black),
            headlineSmall: TextStyle(fontSize: 12.0, color: Colors.black),
            titleLarge: TextStyle(
                fontSize: 20.0, color: Color.fromARGB(255, 8, 83, 180)),
            bodySmall: TextStyle(fontSize: 14, color: Colors.grey)),
        );
      case UserRole.subagent:
      default:
        return ThemeData(
          useMaterial3:false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey[200],
        // splashColor: Colors.pink,
        primaryColor:  const Color.fromARGB(255, 83, 54, 190),
        canvasColor:Colors.white,
        fontFamily: 'Source Sans Pro',
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
        textTheme: const TextTheme(
            titleMedium: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            titleSmall: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromARGB(255, 8, 83, 180),
                fontFamily: 'RaleWay'),
            displayLarge: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                fontSize: 14.0,
                color: Color(0XFF171b34),
                fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 16.0, color: Colors.black),
            headlineMedium: TextStyle(fontSize: 14.0, color: Colors.black),
            headlineSmall: TextStyle(fontSize: 12.0, color: Colors.black),
            titleLarge: TextStyle(
                fontSize: 20.0, color: Color.fromARGB(255, 8, 83, 180)),
            bodySmall: TextStyle(fontSize: 14, color: Colors.grey)),
        );
    }
  }

  void setRole( String? role) {
   
    _currentRole = UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == role,
      orElse: () => UserRole.agent, // Default fallback
    );
    notifyListeners();
  }
}
