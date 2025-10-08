import 'package:crm_generatewealthapp/CRM/contact/contactspage.dart';
import 'package:crm_generatewealthapp/CRM/customer/customerpage.dart';
import 'package:crm_generatewealthapp/CRM/leads/leadspage.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/CRM/search/searchpage.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/notenantpage.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Userprovider _userprovider;
    late Crmprovider _crmProvider;


  Widget clc(currentTheme, contactcount, leadscount, customercount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: (contactcount == null || contactcount == '-')
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ))
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Contactspage(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink.withAlpha(15),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          Colors.pink.withAlpha(100),
                                      child: Icon(
                                        Icons.import_contacts,
                                        color: Colors.white,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).translate("Contacts")}  -  ${contactcount}",
                                      style: currentTheme.textTheme.displayLarge
                                          ?.copyWith(color: Colors.pink),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.pink,
                              )
                            ],
                          ),
                        ))),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: (leadscount == null || leadscount == '-')
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ))
              : InkWell(
                  onTap: () async {
                    // context.loaderOverlay.show();
                    // {
                    //   await _userprovider.getleadstabs(
                    //       _userprovider.selectedworkspace?.branchid);
                    //   context.loaderOverlay.hide();
                    //   // _userprovider.leadsdata(agentid, role, productid);
                    // }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Leadspage(
                            tabbarcount: _crmProvider.leadstabs?.length,
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(15),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          Colors.blue.withAlpha(100),
                                      child: Icon(
                                        Icons.leaderboard_sharp,
                                        color: Colors.white,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).translate("Leads")}  -  ${leadscount}",
                                      style: currentTheme.textTheme.displayLarge
                                          ?.copyWith(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ))),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: (customercount == null || customercount == '-')
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ))
              : InkWell(
                  onTap: () async {
                    // context.loaderOverlay.show();
                    // {
                    //   await _crmProvider.getcustomertabs(
                    //       _crmProvider.selectedworkspace?.branchid);
                    //   context.loaderOverlay.hide();
                    //   // _crmProvider.customersdata(agentid, role, productid);
                    // }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Customerpage(
                            tabbarcount: _crmProvider.customertabs?.length,
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green.withAlpha(15),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          Colors.green.withAlpha(100),
                                      child: Icon(
                                        Icons.group,
                                        color: Colors.white,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${AppLocalizations.of(context).translate("Customers")}  -  ${customercount}",
                                      style: currentTheme.textTheme.displayLarge
                                          ?.copyWith(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ))),
                  )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
        _crmProvider = context.watchcrm;

    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    ;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("CRM"),
            backgroundColor: Color.fromARGB(255, 74, 63, 221),
            actions: [
              IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ProfilePage()));
                  },
                  icon: Icon(Icons.notifications))
            ]),
        body: (_crmProvider.gettabs ||
                _crmProvider.fetchleadstabs ||
                _crmProvider.customerttabs)
            ? Column(
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
              )
            : _crmProvider.stakeholdertypes!.isEmpty
                ? Column(
                    children: [
                      NoTenantPage(
                        content:
                            'This Feautue is disabled for this account. Login to www.vanigam.ai to enable !!',
                      )
                    ],
                  )
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            // _crmProvider.getallsearchdata();
                  
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Searchpage(),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "${AppLocalizations.of(context).translate("common_welcome")}",
                                  style: currentTheme.textTheme.displayLarge,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 30,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey.withAlpha(127),
                                          width: 1.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: Colors.black87,
                                            size: 20,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context).translate("common_search")}',
                                            style: currentTheme
                                                .textTheme.displaySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 4,
                            child: clc(
                              currentTheme,
                              _crmProvider.stakeholdertypes
                                      ?.where((ed) => ed.name == "Contacts")
                                      .toList()
                                      .first
                                      .count ??
                                  0,
                              _crmProvider.stakeholdertypes
                                      ?.where((ed) => ed.name == "Leads")
                                      .toList()
                                      .first
                                      .count ??
                                  0,
                              _crmProvider.stakeholdertypes
                                      ?.where((ed) => ed.name == "Customers")
                                      .toList()
                                      .first
                                      .count ??
                                  0,
                            ),
                          ),
                        )
                      ],
                    ),
                ),
      ),
    );
  }
}
