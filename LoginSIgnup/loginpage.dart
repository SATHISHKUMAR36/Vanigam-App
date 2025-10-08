import 'dart:convert';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/landingpagenew.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool isvisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Userprovider _userProvider;
  RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*()^]).{8,}$');

  void initState() {
    super.initState();
    //  checkIfSignedIn();

    _versioninfo(context);
  }

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Widget _getversiondata() {
    return Container(
        padding: EdgeInsets.all(8),
        child: _packageInfo.version.isNotEmpty
            ? Text(
                "version  " +
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

    return true;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  // Future<void> checkIfSignedIn() async {
  //   context.loaderOverlay.show();
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (prefs.containsKey('loggedInUser')) {
  //     final Map<String, dynamic> userdata =
  //         jsonDecode(prefs.getString('loggedInUser')!);
  //     await _userProvider.loggeduser(userdata);

  //     context.loaderOverlay.hide();
  //     context.readuser.fetchtenants();
  //     if (_userProvider.user != null) {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => LandingPageNew(),
  //           ));
  //     }
  //   }
  //   context.loaderOverlay.hide();
  // }

  Future _forgotpasswordonpressed(context, currentTheme) async {
    final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
    TextEditingController forgotemail = TextEditingController();
    List lst = [];
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("forgotPassword_title"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("forgotPassword_description"),
                  style: currentTheme.textTheme.displayMedium
                      .copyWith(color: Colors.black54, height: 1.3),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey2,
                  child: TextFormField(
                    controller: forgotemail,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate("forgotPassword_email"),
                        labelStyle: currentTheme.textTheme.displaySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      var availableValue = value ?? '';
                      if (availableValue.isEmpty) {
                        return 'Email is requiered..!';
                      } else if (!availableValue.contains('@')) {
                        return "Enter Valid Email";
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("forgotPassword_cancel"),
                    style: currentTheme.textTheme.displayMedium
                        .copyWith(color: Colors.purpleAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(lst = [false]);
                  },
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("forgotPassword_submit"),
                    style: currentTheme.textTheme.displayMedium
                        .copyWith(color: Colors.purpleAccent),
                  ),
                  onPressed: () {
                    if (_formKey2.currentState!.validate()) {
                      Navigator.of(context)
                          .pop(lst = [true, forgotemail.text.trim()]);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return lst;
  }

  _onloginbuttonpressed() async {
    if (_formKey.currentState!.validate()) {
      context.loaderOverlay.show();
      try {
        await context.read<Userprovider>().authuser(
            _emailcontroller.text.trim(), _passwordcontroller.text.trim());

        if (_userProvider.user != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          String? selecteduser = jsonEncode(_userProvider.user);
          await prefs.setString('loggedInUser', (selecteduser));

          context.readuser.fetchtenants();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPageNew(),
              ));
        } else {
          const snackBar = SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Incorrect Email / Password"),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        const snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Incorrect Email / Password"),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    return SafeArea(
        child: Scaffold(
            backgroundColor: currentTheme.canvasColor,
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                // fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.9,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            color: const Color.fromARGB(255, 74, 63, 221)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // width: 70,
                                // height: 70,
                                // color: Colors.white,
                                child: Image.asset(
                                  height: 120,

                                  // alignment: Alignment.center,
                                  "assets/images/vanigamlgog.png",
                                ),
                              ),
                              Text("Vanigam",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: currentTheme.canvasColor),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 275,
                            ),
                            _getversiondata(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 220,
                    child: Card(
                      shadowColor: currentTheme.primaryColor,
                      elevation: 5,
                      child: Container(
                        // height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: currentTheme.canvasColor),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("login_app_title"),
                                    style: TextStyle(
                                        color: currentTheme.primaryColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  //  SizedBox(
                                  //    width: MediaQuery.of(context).size.width / 1,
                                  //    child: Padding(
                                  //      padding: const EdgeInsets.all(10.0),
                                  //      child: TextFormField(
                                  //        controller: _tenantcontroller,
                                  //        decoration: InputDecoration(
                                  //            labelText: 'Tenant',
                                  //            labelStyle: currentTheme.textTheme.displaySmall,
                                  //            prefixIcon:Icon( Icons.home),
                                  //            border: OutlineInputBorder(
                                  //                borderRadius: BorderRadius.circular(10))),
                                  //        validator: (value) {
                                  //          var availableValue = value ?? '';
                                  //          if (availableValue.isEmpty) {
                                  //            return "Tenant name is requiered..!";
                                  //          }
                                  //          return null;
                                  //        },
                                  //      ),
                                  //    ),
                                  //  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        controller: _emailcontroller,
                                        decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)
                                                    .translate("login_email"),
                                            labelStyle: currentTheme
                                                .textTheme.displaySmall,
                                            prefixIcon: Icon(Icons.mail),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        validator: (value) {
                                          var availableValue = value ?? '';
                                          if (availableValue.isEmpty) {
                                            return "Email is required..!";
                                          } else if (!availableValue
                                              .contains('@')) {
                                            return "Enter Valid Email";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        obscureText: isvisible,
                                        controller: _passwordcontroller,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isvisible = !isvisible;
                                                  });
                                                },
                                                icon: Icon(
                                                    isvisible
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: Colors.grey)),
                                            labelText: AppLocalizations.of(
                                                    context)
                                                .translate("login_password"),
                                            labelStyle: currentTheme
                                                .textTheme.displaySmall,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        validator: (value) {
                                          var availableValue = value ?? '';
                                          if (availableValue.isEmpty) {
                                            return "Password is required..!";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          List out =
                                              await _forgotpasswordonpressed(
                                                  context, currentTheme);

                                          if (out[0]) {
                                            context.loaderOverlay.show();

                                            await _userProvider
                                                .forgotpassword(out[1]);
                                            context.loaderOverlay.hide();

                                            if (_userProvider.forgotout
                                                .contains("Success")) {
                                              var snackBar = SnackBar(
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  content: Text(
                                                      _userProvider.forgotout),
                                                  backgroundColor:
                                                      Colors.green);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              context.loaderOverlay.hide();
                                              var snackBar = SnackBar(
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  content: Text(
                                                      _userProvider.forgotout),
                                                  backgroundColor: Colors.red);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("login_fgPass"),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: currentTheme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 20),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: currentTheme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: InkWell(
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "login_app_submit"),
                                              style: TextStyle(
                                                  color:
                                                      currentTheme.canvasColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          onTap: () {
                                            _onloginbuttonpressed();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
