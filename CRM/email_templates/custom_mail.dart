import 'dart:io';

import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/crmapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../../themeprovider.dart';

class CustomMail extends StatefulWidget {
  List emails;
  CustomMail({super.key, required this.emails});

  @override
  State<CustomMail> createState() => _CustomMailState();
}

class _CustomMailState extends State<CustomMail> {
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

  TextEditingController subject = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? htmldata;
  String filename = "No file chosen";

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
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(htmldata!),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:  Text("${AppLocalizations.of(context).translate("CustomMail")}"),
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
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10, top: 50),
                      child: _buildInputField(
                          '${AppLocalizations.of(context).translate("Subject")}', subject, false, Icons.mail, currentTheme)

                      // horizontal_split
                      // list_alt_rounded
                      ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 10, right: 10, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          filename,
                          style: currentTheme.textTheme.displaySmall,
                        ),
                        InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['html'],
                            );

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              PlatformFile files = result.files.first;
                              htmldata = file.readAsStringSync();
                              print(htmldata);

                              setState(() {
                                filename = files.name;
                              });
                            } else {
                              // User canceled the picker
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
                              "${AppLocalizations.of(context).translate("UploadHtmlFlile")}",
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
                        left: 10, right: 10, top: 150, bottom: 20),
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
                                  ?.copyWith(color: currentTheme.primaryColor),
                            ),
                          ),
                          onTap: () async {
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
                              "${AppLocalizations.of(context).translate("SendMail")}",
                              style: TextStyle(
                                  color: currentTheme.canvasColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (filename != "No file chosen") {
                                context.loaderOverlay.show();

                                bool event = await Crmapi.custommail(
                                    subject.text,
                                    widget.emails,
                                    htmldata,
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

                                  Navigator.pop(context);
                                }
                              } else {
                                const snackBar = SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text("Please upload HTML file"),
                                    backgroundColor: Colors.red);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))));
  }
}
