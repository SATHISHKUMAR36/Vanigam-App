import 'dart:io';

import 'package:crm_generatewealthapp/app.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/settingsmodel.dart';
import 'package:crm_generatewealthapp/widget/forceupdate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  initState() {
    context.readuser.vnsettings();
    super.initState();
  }

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  checkForVersionUpdate() async {
    try {
      if (kReleaseMode) {
        var data = await PackageInfo.fromPlatform();

        String? _storeInfo;
        if (Platform.isAndroid) {
          _storeInfo = _userprovider.settings
              ?.where((e) => e.name == "VERSION_ANDROID")
              .toList()
              .first
              .value;
        } else if (Platform.isIOS) {
          _storeInfo = _userprovider.settings
              ?.where((e) => e.name == "VERSION_IOS")
              .toList()
              .first
              .value;
        }
        packageInfo = data;

        if (_storeInfo != null && packageInfo.version.isNotEmpty) {
          var storeversion = _storeInfo.split("+")[0].split(".");
          var storebuild = _storeInfo.split("+")[1];
          var deviceversion = packageInfo.version.split(".");
          var devicebuild = packageInfo.buildNumber;

          if ((num.parse(deviceversion[0]) < num.parse(storeversion[0])) ||
              (num.parse(deviceversion[1]) < num.parse(storeversion[1])) ||
              (num.parse(deviceversion[2]) < num.parse(storeversion[2])) ||
              (num.parse(devicebuild) < num.parse(storebuild))) {
            // clear cache
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Updateapp(),
                ));
            return true;
          } else {
            print("ok");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          }
        } else {
          print("not ok");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
          return false;
        }
      } else if (kDebugMode) {
        Future(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        });
      }
    } on Exception catch (e) {
      print(e);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
      return false;
    }
  }

  List<SettingsModel>? settings;
  late Userprovider _userprovider;
  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    if (settings == null) {
      settings = _userprovider.settings;
      if (settings != null) {
        checkForVersionUpdate();
      }
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset(
              height: 120,

              // alignment: Alignment.center,
              "assets/images/vanigamlgog.png",
            ),
          ),
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.indigo,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
