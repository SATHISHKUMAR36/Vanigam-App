
import 'package:crm_generatewealthapp/CRM/calendar/datetodo.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/event_data_source.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:crm_generatewealthapp/CRM/todo/singletodo.dart';
import 'package:crm_generatewealthapp/CRM/todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late Userprovider _userProvider;
  late Crmprovider _crmProvider;
  late ThemeData currentTheme;

  @override
  void initState() {
    // expenseapi();
    // TODO: implement initState
    super.initState();
  }

  List<Todomodel>? names;

  List<Todomodel>? filterdata;
  List<Todomodel>? data;

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            '${AppLocalizations.of(context).translate("common_delete")}',
            style: currentTheme.textTheme.displayLarge,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  Future<List> _showMyDialog1(context, currentTheme, notes) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController note = TextEditingController();
    note.text = notes;

    List? lst;
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "${AppLocalizations.of(context).translate("AddNote")}",
            style: currentTheme.textTheme.displayLarge,
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: note,
                    decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context).translate("Note")}',
                        labelStyle: currentTheme.textTheme.displaySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      var availableValue = value ?? '';
                      if (availableValue.isEmpty) {
                        return 'Note is requiered..!';
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
                    '${AppLocalizations.of(context).translate("common_cancel")}',
                    style: currentTheme.textTheme.bodySmall
                        .copyWith(color: Colors.purpleAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(lst = [false]);
                  },
                ),
                TextButton(
                  child: Text(
                    '${AppLocalizations.of(context).translate("Ok")}',
                    style: currentTheme.textTheme.bodySmall
                        .copyWith(color: Colors.purpleAccent),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop(lst = [true, note.text]);
                    } else {
                      Navigator.of(context).pop(lst = [true, note.text]);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return lst!;
  }

  color(ctype) {
    switch (ctype) {
      case "Individual":
        return Colors.cyan;
      case "PVT LTD":
        return Colors.blue;

      case "Partnership":
        return Colors.red;

      case "HUF":
        return Colors.pink;

      case "LTD":
        return Colors.deepOrange;

      case "LLP":
        return Colors.purple;

      default:
        return Colors.cyan;
    }
  }

  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        // leading: ShimmerWidget.circular(radius: 60),
        title: ShimmerWidget.rectangular(
          width: MediaQuery.of(context).size.width / 2.1,
          height: 60,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  _showsubcatbottom(currentTheme, appointmentDetails) {
    showModalBottomSheet(
        useSafeArea: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              {
                return Container(
                  color: Colors.grey.withAlpha(25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(appointmentDetails.startTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Divider(
                          thickness: 2,
                        ),
                        _crmProvider.getodo
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  loader(),
                                  loader(),
                                  loader(),
                                ],
                              )
                            : names == null
                                ?  Column(
                                    children: [
Nodatafound(),
              SizedBox(
                height: 65,
              ),                                    ],
                                  )
                                : Column(children: [
                                    ...names!.map((e) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleTodo(
                                                    userid: e.userid,
                                                    access: true,
                                                  ),
                                                ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8, top: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      currentTheme.canvasColor,
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withAlpha(75),
                                                      width: 3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            top: 5,
                                                            bottom: 3),
                                                    child: Row(
                                                      children: [
                                                        // Checkbox(
                                                        //     activeColor: context
                                                        //         .watchtheme
                                                        //         .currentTheme
                                                        //         .primaryColor,
                                                        //     value: dataList[names!
                                                        //             .indexOf(e)]
                                                        //         ["isChecked"],
                                                        //     onChanged:
                                                        //         (bool? value) {
                                                        //       setState(() {
                                                        //         //
                                                        //         select =
                                                        //             "Select all";
                                                        //         dataList[names!
                                                        //                 .indexOf(
                                                        //                     e)][
                                                        //             "isChecked"] = !dataList[
                                                        //                 names!
                                                        //                     .indexOf(
                                                        //                         e)]
                                                        //             ["isChecked"];
                                                        //       });
                                                        //     }),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              e.name ?? '',
                                                              style: currentTheme
                                                                  .textTheme
                                                                  .displayLarge
                                                                  ?.copyWith(
                                                                      color: currentTheme
                                                                          .primaryColor),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(
                                                              e.stackholdertype ??
                                                                  '',
                                                              style: currentTheme
                                                                  .textTheme
                                                                  .displayMedium,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        e.actiontype == 'Call'
                                                            ? Icons.call
                                                            : Icons
                                                                .document_scanner,
                                                        size: 18,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          e.actiontype ?? "",
                                                          style: currentTheme
                                                              .textTheme
                                                              .displaySmall,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  ]),
                      ]),
                );
              }
            });
          }
        });
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    if (details.appointments.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: details.date == date
                  ? Text(
                      details.date.day.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      details.date.day.toString(),
                      textAlign: TextAlign.center,
                    ),
            ),
            Divider(
              color: Colors.transparent,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(8),
      child: details.date == date
          ? Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold),
            )
          : Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
            ),
    );
  }

  void calendarTapped(
    CalendarTapDetails details,
  ) {
    if ((details.targetElement == CalendarElement.appointment ||
            details.targetElement == CalendarElement.calendarCell) &&
        details.appointments!.isNotEmpty) {
      _crmProvider
          .datetododata(_userProvider.selectedworkspace?.branchid,DateFormat("yyyy-MM-dd").format(details.date!));
      // final Appointment appointmentDetails = details.appointments![0];
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Datetodo(
                date: DateFormat("yyyy-MM-dd").format(details.date!),
                len: details.appointments?.length),
          ));

      // _showsubcatbottom(currentTheme, appointmentDetails);
    }
  }

  EventDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    _crmProvider.calendar?.forEach((element) {
      if (element.contactcount != null) {
        appointments.add(Appointment(
          startTime: DateTime.parse(element.date!),
          endTime: DateTime.parse(element.date!),
          subject: 'Cont -${element.contactcount}',
          color: Colors.pink,
          startTimeZone: '',
          endTimeZone: '',
        ));
      }
      if (element.leadcount != null) {
        appointments.add(Appointment(
          startTime: DateTime.parse(element.date!),
          endTime: DateTime.parse(element.date!),
          subject: 'Lead -${element.leadcount}',
          color: Colors.lightBlue,
          startTimeZone: '',
          endTimeZone: '',
        ));
      }
      if (element.customercount != null) {
        appointments.add(Appointment(
          startTime: DateTime.parse(element.date!),
          endTime: DateTime.parse(element.date!),
          subject: 'Cust -${element.customercount}',
          color: Colors.green,
          startTimeZone: '',
          endTimeZone: '',
        ));
      }
    });

    return EventDataSource(appointments);
  }

  sortdata() {
    data = _crmProvider.todo;
    names = data;
  }

  @override
  Widget build(BuildContext context) {
    _crmProvider = context.watchcrm;
    _userProvider = context.watchuser;
    currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    if (names == null) {
      sortdata();
    }

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              elevation: 1,
              centerTitle: true,
              title: Text("${AppLocalizations.of(context).translate("Calender")}",
                  style: TextStyle(
                      color: currentTheme.canvasColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              backgroundColor: currentTheme.primaryColor,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.73,
                        child: SfCalendar(
                          cellBorderColor: currentTheme.primaryColor,
                          view: CalendarView.month,
                          showNavigationArrow: true,
                          viewHeaderStyle: ViewHeaderStyle(
                            dayTextStyle: currentTheme.textTheme.headlineSmall,
                          ),
                          headerStyle: CalendarHeaderStyle(
                              textStyle: currentTheme.textTheme.displayLarge!
                                  .copyWith(color: currentTheme.primaryColor),
                              textAlign: TextAlign.center),
                          onTap: calendarTapped,
                          initialSelectedDate: DateTime.now(),
                          dataSource: _getCalendarDataSource(),
                          todayHighlightColor: currentTheme.primaryColor,
                          todayTextStyle: TextStyle(
                              color:
                                  context.watchtheme.currentTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                          monthCellBuilder: monthCellBuilder,
                          monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment,
                            showTrailingAndLeadingDates: false,
                          ),
                          selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: currentTheme.primaryColor, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
