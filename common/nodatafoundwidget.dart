import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:flutter/material.dart';

class Nodatafound extends StatelessWidget {
  double? height;
  Nodatafound({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = context.watchtheme.currentTheme;
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: height ?? 100),
      child: Column(
        children: [
          SizedBox(
            height: height ?? 40,
          ),
          Image.asset(
            "assets/images/ndf.png",
            height: 200,
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Text(
              "${AppLocalizations.of(context).translate("NoDataFound")}",
              style: currentTheme.textTheme.displayMedium
                  ?.copyWith(color: Colors.black45),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
