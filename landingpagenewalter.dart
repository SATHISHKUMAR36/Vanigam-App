import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/dashboardpage.dart';
import 'package:crm_generatewealthapp/employeemanagement/employeeview.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:crm_generatewealthapp/user_management/usermanagementview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Landingpagenewalter extends StatefulWidget {
  int? selectedIndex;
  Landingpagenewalter({super.key, this.selectedIndex});

  @override
  State<Landingpagenewalter> createState() => _LandingpagenewalterState();
}

class _LandingpagenewalterState extends State<Landingpagenewalter> {
  late Userprovider _userprovider;
  PageController controller = PageController();

  late List<Widget> pages = [
    DashboardPage(),
    UserManagementView(),
    Employeeview()
  ];

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''

              // label: "Home",
              ),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: ''
              // label: "       User\nManagement",
              ),
          BottomNavigationBarItem(icon: Icon(Icons.groups_3), label: ''
              // label: "   Employee\nManagement",
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
