import 'dart:convert';

import 'package:crm_generatewealthapp/LoginSIgnup/loginpage.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    super.initState();

    _versioninfo(context);
  }

  Widget _getversiondata() {
    return Container(
        padding: EdgeInsets.all(8),
        child: _packageInfo.version.isNotEmpty
            ? Text(
                "${AppLocalizations.of(context).translate("version")}  " +
                    _packageInfo.version +
                    " + " +
                    _packageInfo.buildNumber,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12))
            : Text(""));
  }

  Future<bool> _versioninfo(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }

    deflanguage = context.readuser.deflangugage;

    // This is called when the user selects an item.

    return true;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  String? deflanguage;
  signOutAction() async {
    try {
      context.loaderOverlay.show();
      await context.readuser.logoutUser();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e);
    } finally {
      context.loaderOverlay.hide();
    }
  }

  late Userprovider _userprovider;

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context).translate("Profile")}'),
        backgroundColor: Color.fromARGB(255, 74, 63, 221),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Icon
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    Color.fromARGB(255, 74, 63, 221).withAlpha(100),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // User info
              Text(
                (context.readuser.user?.firstname ?? '') +
                    " " +
                    (context.readuser.user?.lastname ?? ''),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                context.readuser.user?.email ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, right: 10, left: 10, top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: Icon(Icons.language, color: Colors.indigo),
                            ),
                            Text(
                                "${AppLocalizations.of(context).translate("Language")}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 7, bottom: 7),
                        child: DropdownButton<String>(
                          value: deflanguage,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          // underline: Container(height: 2, color: Colors.deepPurpleAccent),
                          onChanged: (String? value) async {
                            context.loaderOverlay.show();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String language = value ?? "English";
                            await prefs.setString('Locale', (language));
                            await context.readuser.updatelanguage(language);
                            // This is called when the user selects an item.

                            // changeLanguage();
                            ;
                            if (value == "Tamil") {
                              myAppKey.currentState!
                                  .changeLanguage(Locale("ta", ''));
                            } else {
                              myAppKey.currentState!
                                  .changeLanguage(Locale("en", ''));
                            }
                            setState(() {
                              deflanguage = value!;
                            });

                            context.loaderOverlay.hide();
                          },
                          items: ["English", "Tamil"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => signOutAction(),
                  icon: Icon(Icons.logout),
                  label: Text(
                      '${AppLocalizations.of(context).translate("LogOut")}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 74, 63, 221),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              _getversiondata(),
            ],
          ),
        ),
      ),
    );
  }
}
