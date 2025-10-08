import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
export 'package:crm_generatewealthapp/config.dart';

// String APIGATEWAYBASEURL = "https://qa6rkwnf41.execute-api.ap-south-1.amazonaws.com/dev";

String PLAYSTORELINK =
    "https://play.google.com/store/apps/details?id=ai.vanigam.crm&hl=en_IN";
String APPSTORELINK =
    "https://play.google.com/store/apps/details?id=ai.vanigam.crm&hl=en_IN";

List<String> catypelist = [
  "Individual",
  "Partnership",
  "PVT LTD",
  "HUF",
  "LTD",
  "LLP"
];

Widget circleLoader(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
        color: context.watchtheme.currentTheme.scaffoldBackgroundColor,
        backgroundColor: context.watchtheme.currentTheme.primaryColor),
  );
}

String commaSepartor(num value, {int digit = 2}) {
  NumberFormat numberFormat = NumberFormat.decimalPattern('en_IN');
  return numberFormat.format(num.parse(value.toStringAsFixed(digit)));
}

// ignore: constant_identifier_names
enum CAProducts { GST, ADVTAX, AnnualTax, Notices }

extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}
