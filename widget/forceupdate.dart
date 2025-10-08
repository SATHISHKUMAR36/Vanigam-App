import 'dart:io';

import 'package:crm_generatewealthapp/common/constant.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Updateapp extends StatefulWidget {
  const Updateapp({
    super.key,
  });

  @override
  State<Updateapp> createState() => _UpdateappState();
}

class _UpdateappState extends State<Updateapp> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 300,
                  child: Image.asset(
                    "assets/images/vanigamlgog.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("App Update available",
                      style: currentTheme.textTheme.displayLarge!
                      // .copyWith(color: Colors.white),
                      ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("To use this app, download the latest version.",
                        style: currentTheme.textTheme.displayLarge!
                        // .copyWith(color: Colors.white),
                        )),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.indigo, // This is what you need!
                      ),
                      onPressed: () {
                        if (Platform.isAndroid)
                          launchUrlString(
                            PLAYSTORELINK,
                            mode: LaunchMode.externalApplication,
                          );
                        if (Platform.isIOS)
                          launchUrlString(
                            APPSTORELINK,
                            mode: LaunchMode.externalApplication,
                          );
                      },
                      child: Text(
                        "UPDATE NOW",
                        style: currentTheme.textTheme.displayLarge
                            ?.copyWith(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
