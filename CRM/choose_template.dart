import 'package:crm_generatewealthapp/CRM/email_templates/custom_mail.dart';
import 'package:crm_generatewealthapp/CRM/email_templates/event_alert.dart';
import 'package:crm_generatewealthapp/CRM/email_templates/join_event.dart';
import 'package:crm_generatewealthapp/CRM/email_templates/thankumail.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseTemplate extends StatefulWidget {
  List emails;
  ChooseTemplate({super.key, required this.emails});

  @override
  State<ChooseTemplate> createState() => _ChooseTemplateState();
}

class _ChooseTemplateState extends State<ChooseTemplate> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Email Templates"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        backgroundColor: currentTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose the email template's",
                      style: currentTheme.textTheme.displayLarge,
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventAlert(
                              emails: widget.emails,
                            ),
                          ));
                    },
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: Border.all(color: Colors.white, width: 5),
                          child: Image.asset(
                              height: MediaQuery.of(context).size.height / 3.5,
                              "assets/images/event_alert.jpg"),
                        ),
                        Text(
                          "Event alert mail",
                          style: currentTheme.textTheme.displayMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JoinEvent(emails: widget.emails),
                          ));
                    },
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: Border.all(color: Colors.white, width: 5),
                          child: Image.asset(
                              height: MediaQuery.of(context).size.height / 3.5,
                              "assets/images/join_event.jpg"),
                        ),
                        Text(
                          "Join Event mail",
                          style: currentTheme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ThankuMail(emails: widget.emails),
                          ));
                    },
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: Border.all(color: Colors.white, width: 5),
                          child: Image.asset(
                              height: MediaQuery.of(context).size.height / 3.5,
                              "assets/images/thanku.jpg"),
                        ),
                        Text(
                          "Thank you mail",
                          style: currentTheme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomMail(emails: widget.emails),
                          ));
                    },
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: Border.all(color: Colors.white, width: 5),
                          child: Image.asset(
                              height: MediaQuery.of(context).size.height / 3.5,
                              "assets/images/custom.jpg"),
                        ),
                        Text(
                          "Custom mail",
                          style: currentTheme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
