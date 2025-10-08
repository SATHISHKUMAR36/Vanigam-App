import 'package:crm_generatewealthapp/CRM/calendar/calender.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/CRM/homepage.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/CRM/todo/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../themeprovider.dart';

class Landingpage extends StatefulWidget {
  Landingpage({super.key});

  int? selectedIndex;

  @override
  State<Landingpage> createState() => _LandingPageState();
}

class _LandingPageState extends State<Landingpage> {
  late Userprovider _userprovider;
  PageController controller = PageController();

  late List<Widget> pages = [Homepage(), Calender(), Todo()];

  late int _selectedIndex;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
      controller = PageController(initialPage: _selectedIndex);
    } else {
      _selectedIndex = 0;
    }

    super.initState();
  }

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Exit_app",
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text("Are you sure , want to exit now?",
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return exitApp!;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userprovider = context.watchuser;
    return Scaffold(
      body: PageView(
        children: pages,
        scrollDirection: Axis.horizontal,

        // reverse: true,
        // physics: BouncingScrollPhysics(),
        controller: controller,
        onPageChanged: (num) {
          setState(() {
            _selectedIndex = num;
          });
        },
      ),
      // body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // shape: const CircularNotchedRectangle(),
        type: BottomNavigationBarType.fixed,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "${AppLocalizations.of(context).translate("CRM_Home")}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "${AppLocalizations.of(context).translate("CRM_Calendar")}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "${AppLocalizations.of(context).translate("CR_ToDO")}",
          ),
        ],
        selectedItemColor: currentTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,

        onTap: (value) {
          controller.jumpToPage(value);
        },
      ),
    );
  }
}
