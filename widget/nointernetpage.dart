
// import 'package:crm_generatewealthapp/common/contextextension.dart';
// import 'package:flutter/material.dart';


// class NoInternetPage extends StatefulWidget {
//   final void Function(Locale) onLanguageChanged;
//    NoInternetPage({super.key, required this.onLanguageChanged});

//   @override
//   State<NoInternetPage> createState() => _NoInternetPageState();
// }

// class _NoInternetPageState extends State<NoInternetPage> {

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = context.watchtheme.currentTheme;
//     return Center(
//   child: Container(
//     color: Colors.white,
//     padding: EdgeInsets.all(32),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//          Image.asset(
//                 'assets/images/network.png',
//                 fit: BoxFit.cover,
//                 height: 50.0,
//               ),
//         SizedBox(
//           height: 20,
//         ),
//         Text(
//           "No Internet connection found. Check your connection and try again.",
//           style: currentTheme.textTheme.displaySmall,
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         ElevatedButton.icon(
//           onPressed: () {
//             context.readconnectivity.retryConnection();
//             // Retry logic here
//             // For example, you can call a function to retry connecting
//             // or refresh the network status.
//             Navigator.push(context, MaterialPageRoute(builder: (context) => SplashPage(onLanguageChanged: widget.onLanguageChanged),));
//           },
//           icon: Icon(Icons.refresh), // Icon for retry
//           label: Text("Retry"),
//         ),
//       ],
//     ),
//   ),
// );
//   }
// }
