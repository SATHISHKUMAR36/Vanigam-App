import 'dart:convert';

import 'package:crm_generatewealthapp/LoginSIgnup/loginpage.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/landingpagenew.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkIfSignedIn();
  }

  Future<void> checkIfSignedIn() async {
    context.loaderOverlay.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('loggedInUser')) {
      final Map<String, dynamic> userdata =
          jsonDecode(prefs.getString('loggedInUser')!);
      await context.readuser.loggeduser(userdata);

      context.loaderOverlay.hide();
      context.readuser.fetchtenants();
      if (context.readuser.user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPageNew(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Loginpage(),
            ));
      }
    } else {
      context.loaderOverlay.hide();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Loginpage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Container()),
    );
  }
}
