import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/dashboardpage.dart';
import 'package:crm_generatewealthapp/landingpagenewalter.dart';
import 'package:crm_generatewealthapp/notenantpage.dart';
import 'package:crm_generatewealthapp/profilepage.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/tenantspage.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageNew extends StatefulWidget {
  const LandingPageNew({super.key});

  @override
  State<LandingPageNew> createState() => _LandingPageNewState();
}

class _LandingPageNewState extends State<LandingPageNew> {
  late Userprovider _userprovider;
  late SharedPreferences prefs;
  late ThemeData currentTheme;

  @override
  void initState() {
    setprefs();

    super.initState();
  }

  setprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _alertdialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              surfaceTintColor: currentTheme.splashColor,
              content: Text(
                "Do you want to exit from the application?",
                style: currentTheme.textTheme.bodyMedium,
              ),
              title: Text(
                "Exit App",
                style: currentTheme.textTheme.bodySmall,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('NO',
                      style:
                          TextStyle(color: Color.fromARGB(255, 193, 36, 233))),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: const Text('YES',
                      style:
                          TextStyle(color: Color.fromARGB(255, 193, 36, 233))),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ]);
        });
  }

  Widget? getcontent() {
    if (_userprovider.tenants.isNotEmpty) {
      if (_userprovider.selectedtenant != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Landingpagenewalter()));
        });
      } else {
        return PopScope(
          canPop: false,
          onPopInvoked: (didpop) async {
            if (didpop) {
              return;
            }
            _alertdialog(context);
          },
          child: RefreshIndicator(
              onRefresh: () async {
                await _userprovider.fetchtenants();
              },
              child: SingleChildScrollView(child: TenantsPage())),
        );
      }
    } else {
      return PopScope(
        canPop: false,
        onPopInvoked: (didpop) async {
          if (didpop) {
            return;
          }
          _alertdialog(context);
        },
        child: RefreshIndicator(
            onRefresh: () async {
              await _userprovider.fetchtenants();
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: NoTenantPage(content: 'No Business Added for this account yet. Login to www.vanigam.ai to add your business !!',))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userprovider = context.watchuser;
    currentTheme = context.watchtheme.currentTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 74, 63, 221),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                icon: Icon(Icons.person_2_outlined))
          ],
        ),
        body: _userprovider.istenantsfetching
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ShimmerWidget.rectangular(
                        height: 100,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ShimmerWidget.rectangular(
                        height: 100,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ],
                  ),
                ),
              )
            : getcontent(),
      ),
    );
  }
}
