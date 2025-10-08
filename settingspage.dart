import 'package:crm_generatewealthapp/LoginSIgnup/loginpage.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? lst;
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Logout",
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text("Are you sure, do you want logout?",
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(lst = false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(lst = true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return lst!;
  }

  signOutAction(context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Loginpage()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(color: currentTheme.canvasColor),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
          backgroundColor: currentTheme.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: currentTheme.canvasColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          bool out = await _showMyDialog(context, currentTheme);
                          if (out) {
                            signOutAction(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: SizedBox(
                                      width: 40,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            currentTheme.primaryColor,
                                        radius: 20,
                                        child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.canvasColor,
                                            radius: 16,
                                            child: const Icon(
                                              Icons.logout_outlined,
                                              color: Colors.black,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Logout",
                                    style: currentTheme.textTheme.displayMedium,
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: currentTheme.primaryColor,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
