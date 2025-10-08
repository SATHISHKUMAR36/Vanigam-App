import 'package:crm_generatewealthapp/CRM/calendar/datetodomodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/singledatetodo.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Datetodo extends StatefulWidget {
  String? date;
  int? len;
  Datetodo({super.key, this.date, this.len});

  @override
  State<Datetodo> createState() => _TodoState();
}

class _TodoState extends State<Datetodo> {
  late Userprovider _userProvider;
  late Crmprovider _crmProvider;

  List<Datetodomodel>? names;
  List<Map<String, dynamic>> dataList = [];
  List<Datetodomodel>? data;
  sortdata() {
    data = _crmProvider.datetodo;
    names = data;
  }

  stckcolor(name) {
    switch (name) {
      case 'Contact':
        return Colors.pink;
      case 'Lead':
        return Colors.lightBlue;
      case 'Customer':
        return Colors.green;
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

  onSearchTextChanged(String text) {
    var pattern = text.toLowerCase();
    if (pattern.isNotEmpty) {
      names = [];
      names!.addAll(data!.where((element) =>
          element.name!.toLowerCase().contains(pattern) ||
          element.email!.toLowerCase().contains(pattern) ||
          element.status!.toLowerCase().contains(pattern)));
    } else {
      names = data;
    }

    if (mounted) setState(() {});
  }

  String select = "Select all";
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    _crmProvider = context.watchcrm;

    if (names == null || names!.isEmpty) {
      sortdata();
    }

    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.date ?? ''),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )),
          backgroundColor: currentTheme.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width / 2.1,
              //       child: Center(
              //         child: TextFormField(
              //           onChanged: onSearchTextChanged,
              //           controller: search,
              //           decoration: InputDecoration(
              //               contentPadding: const EdgeInsets.only(
              //                   top: 20,
              //                   left: 10), // add padding to adjust text
              //               isDense: true,
              //               hintText: 'Search',
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10))),
              //           validator: (value) {
              //             var availableValue = value ?? '';
              //             if (availableValue.isEmpty) {
              //               return ("Enter Name!");
              //             }
              //             return null;
              //           },
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         dataList.clear();
              //         if (select == "Select all") {
              //           setState(() {
              //             select = "Deselect all";
              //             for (int i = 0; i < data!.length; i++) {
              //               dataList.add(
              //                   {"email": data?[i].email, "isChecked": true});
              //             }
              //           });
              //         } else {
              //           setState(() {
              //             select = "Select all";
              //             for (int i = 0; i < data!.length; i++) {
              //               dataList.add(
              //                   {"email": data?[i].email, "isChecked": false});
              //             }
              //           });
              //         }
              //       },
              //       child: Container(
              //         width: 120,
              //         height: 40,
              //         decoration: BoxDecoration(
              //             color: currentTheme.primaryColor.withAlpha(50),
              //             borderRadius: BorderRadius.circular(10)),
              //         child: Center(
              //             child: Text(select,
              //                 style: currentTheme.textTheme.displayLarge
              //                     ?.copyWith(
              //                         color: currentTheme.primaryColor))),
              //       ),
              //     )
              //   ],
              // ),
              SingleChildScrollView(
                child: _crmProvider.getdatetodo
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(widget.len ?? 0, (index) => loader())
                        ],
                      )
                    : Column(children: [
                        ...?names?.map((e) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Singledatetodo(
                                        userid: e.userid,
                                        access: true,
                                        date: widget.date,
                                        productid: _userProvider.userdata
                                            ?.productlist?.first['productid'],
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8, top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: currentTheme.canvasColor,
                                      border: Border.all(
                                          color: Colors.grey.withAlpha(75),
                                          width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 5, bottom: 3),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name ?? '',
                                                  style: currentTheme
                                                      .textTheme.displayLarge
                                                      ?.copyWith(
                                                          color: currentTheme
                                                              .primaryColor),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  e.stackholdertype ?? '',
                                                  style: currentTheme
                                                      .textTheme.displayMedium,
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
                                                : Icons.document_scanner,
                                            size: 18,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              e.actiontype ?? "",
                                              style: currentTheme
                                                  .textTheme.displaySmall,
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
              ),
            ],
          ),
        ));
  }
}
