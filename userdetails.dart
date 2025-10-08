import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("My details",style: TextStyle(color: currentTheme.canvasColor),),
          shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
          backgroundColor: currentTheme.primaryColor,
          automaticallyImplyLeading: false,
      ),
      body: Column(),
    ));
  }
}