import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/provider/crmapi.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ThankuMail extends StatefulWidget {
  List emails;
  ThankuMail({super.key, required this.emails});

  @override
  State<ThankuMail> createState() => _ThankuMailState();
}

class _ThankuMailState extends State<ThankuMail> {
  String? htmldata;
  Future _showMyDialog(context, currentTheme) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "${AppLocalizations.of(context).translate("PreviewMail")}",
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(htmldata!),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  '${AppLocalizations.of(context).translate("Close")}',
                  style: TextStyle(color: Colors.purpleAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(
    String label,
    // Function(String?) onSaved,
    TextEditingController controller,
    bool link,
    IconData icon,
    currentTheme, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: currentTheme.textTheme.displayMedium
              .copyWith(color: currentTheme.primaryColor),
          prefixIcon: Icon(icon, color: currentTheme.primaryColor),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (link && !value.contains('http')) {
            return 'Please enter link only';
          }
          return null;
        },
        // onSaved: onSaved,
      ),
    );
  }

  String headerfilename = "No file chosen";
  String? headerlink;

  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now().add(Duration(days: 3));

  Future<void> selectDate(BuildContext context, currentTheme) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: currentdate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: currentTheme.primaryColor, // header background color
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      currentdate = selectedDate ?? DateTime.now().add(Duration(days: 3));
    });
  }

  late Userprovider _userprovider;
    late Crmprovider _crmProvider;


  TextEditingController title = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController altheader = TextEditingController();
  TextEditingController centertext = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userprovider = context.watchuser;
        _crmProvider = context.watchcrm;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("${AppLocalizations.of(context).translate("Thank_you_mail")}"),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              )),
              backgroundColor: currentTheme.primaryColor,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: _buildInputField(
                            '${AppLocalizations.of(context).translate("Title")}', title, false, Icons.mail, currentTheme)),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: _buildInputField('${AppLocalizations.of(context).translate("Subject")}', subject, false,
                            Icons.horizontal_split, currentTheme)

                        // horizontal_split
                        // list_alt_rounded
                        ),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: _buildInputField(
                            '${AppLocalizations.of(context).translate("AltSubject")}',
                            altheader,
                            false,
                            Icons.list_alt_rounded,
                            currentTheme)

                        // horizontal_split
                        // list_alt_rounded
                        ),

                    // horizontal_split
                    // list_alt_rounded
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: _buildInputField('${AppLocalizations.of(context).translate("Center_Text")}', centertext,
                            false, Icons.center_focus_strong, currentTheme)

                        // horizontal_split
                        // list_alt_rounded
                        ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            selectDate(context, currentTheme);
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: currentTheme.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context).translate("ChooseEventdate")}",
                                        style: currentTheme
                                            .textTheme.displayMedium
                                            ?.copyWith(
                                                color: currentTheme.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(currentdate ??
                                              DateTime.now()
                                                  .add(Duration(days: 3)))
                                          .toString(),
                                      style: TextStyle(
                                          color: currentTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Text(
                              headerfilename,
                              style: currentTheme.textTheme.displayMedium,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg'],
                              );

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                PlatformFile files = result.files.first;
                                Uint8List image = await file.readAsBytes();

                                context.loaderOverlay.show();
                                await _crmProvider.uploadimageins3(
                                    base64Encode(image),
                                    DateFormat('yyyy-MM-dd')
                                        .format(currentdate ??
                                            DateTime.now()
                                                .add(Duration(days: 3)))
                                        .toString(),
                                    files.extension,
                                    files.name);
                                context.loaderOverlay.hide();
                                setState(() {
                                  headerfilename = files.name;
                                  headerlink = _crmProvider.s3link;
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: currentTheme.primaryColor.withAlpha(50),
                              ),
                              child: Center(
                                  child: Text(
                                "${AppLocalizations.of(context).translate("Upload_header")}",
                                style: currentTheme.textTheme.displayLarge!
                                    .copyWith(color: currentTheme.primaryColor),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 30, bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.primaryColor.withAlpha(50),
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                "${AppLocalizations.of(context).translate("PreviewMail")}",
                                style: currentTheme.textTheme.displayLarge
                                    ?.copyWith(
                                        color: currentTheme.primaryColor),
                              ),
                            ),
                            onTap: () async {
                              context.loaderOverlay.show();
                              htmldata = await Crmapi.previewthankumail(
                                  subject.text,
                                  widget.emails,
                                  headerlink,
                                  title.text,
                                  altheader.text,
                                  centertext.text,
                                  "xcaldata");
                              context.loaderOverlay.hide();
                              if (htmldata != null) {
                                _showMyDialog(context, currentTheme);
                              } else {
                                const snackBar = SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text("Please Upload HTML File..!"),
                                    backgroundColor: Colors.red);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context).translate("Send_Email")}",
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (headerlink != null) {
                                    context.loaderOverlay.show();
                                    bool event = await Crmapi.thankumail(
                                        subject.text,
                                        widget.emails,
                                        headerlink,
                                        title.text,
                                        altheader.text,
                                        centertext.text,
                                        "xcaldata");
                                    context.loaderOverlay.hide();

                                    if (event) {
                                      const snackBar = SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text("Success"),
                                          backgroundColor: Colors.green);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      Navigator.pop(context);
                                    } else {
                                      const snackBar = SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text("Failed"),
                                          backgroundColor: Colors.red);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } else {
                                    const snackBar = SnackBar(
                                        duration: Duration(seconds: 3),
                                        content:
                                            Text("Please upload header image"),
                                        backgroundColor: Colors.red);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
