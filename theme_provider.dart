// import 'package:flutter/material.dart';

// class ThemeProvider extends ChangeNotifier {
//   ThemeMode themeMode = ThemeMode.light;
//   bool get isDarkMode => themeMode == ThemeMode.dark;

//   void toggleTheme(bool isOn) {
//     themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }

//   ThemeData get currentTheme {
//     return themeMode == ThemeMode.dark
//         ? MyThemes.darkTheme.data
//         : MyThemes.lightTheme.data;
//   }

//   MyThemedata get mycurrentTheme {
//     return themeMode == ThemeMode.dark
//         ? MyThemes.darkTheme
//         : MyThemes.lightTheme;
//   }
// }

// class MyThemedata {
//   ThemeMode themeMode;
//   final ThemeData data;
//   final Color? containercolor;
//   final TextStyle? profiletext;
//   final TextStyle? portfolio;
//   final TextStyle? userinfocolor;
//   MyThemedata(this.themeMode, this.data,
//       {this.containercolor,
//       this.profiletext,
//       this.portfolio,
//       this.userinfocolor});
// }

// class MyThemes {
//   static final darkTheme = MyThemedata(
//     ThemeMode.dark,
//     ThemeData(
//        useMaterial3:false,
//       brightness: Brightness.dark,
//       scaffoldBackgroundColor: const Color(0XFF4C4C4C),
//       splashColor: Colors.white,
//       primaryColor: Colors.black38,
//       fontFamily: 'Source Sans Pro',
//       textTheme: const TextTheme(
//         displayLarge: TextStyle(
//             fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
//         displayMedium: TextStyle(
//             fontSize: 14.0,
//             color: Color(0XFFCE93D8),
//             fontWeight: FontWeight.bold),
//         displaySmall: TextStyle(fontSize: 16.0, color: Colors.white),
//         headlineMedium: TextStyle(fontSize: 14.0, color: Colors.white),
//         headlineSmall: TextStyle(fontSize: 12.0, color: Colors.white),
//         titleLarge: TextStyle(fontSize: 10.0, color: Colors.white),
//       ),
//       iconTheme: const IconThemeData(color: Colors.white),
//       colorScheme: const ColorScheme.dark()
//           .copyWith(secondary: Color(0XFFAB47BC))
//           .copyWith(background: Color(0XFF4C4C4C)),
//     ),
//   );
//   static final lightTheme = MyThemedata(
//       ThemeMode.light,
//       ThemeData(
//         useMaterial3:false,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.blue,
//         ),
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: Colors.grey[200],
//         // splashColor: Colors.pink,
//         primaryColor:  Colors.indigo[500],
//         canvasColor:Colors.white,
//         fontFamily: 'Source Sans Pro',
//         textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
//         textTheme: const TextTheme(
//             titleMedium: TextStyle(
//                 fontSize: 16,
//                 color: Color.fromARGB(255, 8, 83, 180),
//                 fontFamily: 'RaleWay'),
//             titleSmall: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color.fromARGB(255, 8, 83, 180),
//                 fontFamily: 'RaleWay'),
//             displayLarge: TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//             displayMedium: TextStyle(
//                 fontSize: 14.0,
//                 color: Color(0XFF171b34),
//                 fontWeight: FontWeight.bold),
//             displaySmall: TextStyle(fontSize: 16.0, color: Colors.black),
//             headlineMedium: TextStyle(fontSize: 14.0, color: Colors.black),
//             headlineSmall: TextStyle(fontSize: 12.0, color: Colors.black),
//             titleLarge: TextStyle(
//                 fontSize: 20.0, color: Color.fromARGB(255, 8, 83, 180)),
//             bodySmall: TextStyle(fontSize: 14, color: Colors.grey)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         colorScheme: const ColorScheme.light()
//             .copyWith(
//                 primaryContainer: Color.fromARGB(255, 185, 115, 182),
//                 secondary: Color.fromARGB(255, 8, 154, 180),
//                 tertiary: Color.fromARGB(255, 109, 67, 117))
//             .copyWith(background: Colors.white24),
//       ),
//       // containercolor: const Color.fromARGB(255, 180, 8, 170),
//       profiletext: const TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//           color: Color.fromARGB(255, 10, 10, 10),
//           fontFamily: 'RaleWay'),
//       portfolio: const TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//           color: Color.fromARGB(255, 10, 10, 10),
//           fontFamily: 'RaleWay'),
//       userinfocolor: const TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 24,
//           color: Color.fromARGB(255, 245, 242, 242),
//           fontFamily: 'RaleWay'));
// }
