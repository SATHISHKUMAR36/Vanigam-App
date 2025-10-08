import 'dart:async';

import 'package:crm_generatewealthapp/CRM/choose_template.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/CRM/contact/edit_contact.dart';
import 'package:crm_generatewealthapp/CRM/customer/customermodel.dart';
import 'package:crm_generatewealthapp/CRM/customer/singlecustomer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../../themeprovider.dart';

class Customerpage extends StatefulWidget {
  String? productid;
  int? tabbarcount;
  String? agentid;
  String? role;
  Customerpage(
      {super.key, this.productid, this.tabbarcount, this.agentid, this.role});

  @override
  State<Customerpage> createState() => _CustomerpageState();
}

class _CustomerpageState extends State<Customerpage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabbarcount ?? 0, vsync: this);
  }

  color(ctype) {
    switch (ctype) {
      case "Active":
        return Colors.green;

      case "Research Yearly":
        return Colors.teal;

      case "Research Monthly":
        return Colors.blueAccent;

      default:
        return Colors.cyan;
    }
  }

  List<List<Customers>?>? alltabs;
  List<List<Map<String, dynamic>>?>? alldataLists = [];
  List<String?>? selectall = [];
  List<dynamic>? tabs;
  List<int?>? counts;

  Future<List> _showMyDialog(context, currentTheme, List<String?> typelist,
      deftype, stakeholdertype) async {
    List? lst;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "${AppLocalizations.of(context).translate("moveto")} ${stakeholdertype}}",
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 60,
                        // width:MediaQuery.of(context).size.width/,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    "${AppLocalizations.of(context).translate("SelectType")} :",
                                    style: currentTheme.textTheme.displayMedium!
                                        .copyWith(
                                            color: currentTheme.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: DropdownButton(
                                  // Initial Value
                                  value: deftype,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: typelist.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e ?? ''),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (newValue) {
                                    setState(() {
                                      deftype = newValue;
                                    });
                                  },
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      '${AppLocalizations.of(context).translate("Cancel")}',
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = [false]);
                    },
                  ),
                  TextButton(
                    child: Text(
                      '${AppLocalizations.of(context).translate("Ok")}',
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = [true, deftype]);
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
    return lst!;
  }

  onSearchTextChanged(String? text, filterlist, listtype, index) {
    var pattern = text?.toLowerCase().trim();
    if (pattern != null) {
      alltabs?[index] = [];
      alltabs?[index]!.addAll(data!.where((element) =>
          ((element.name?.toLowerCase().contains(pattern) ?? false) ||
              (element.email?.toLowerCase().contains(pattern) ?? false) ||
              (element.address?.toLowerCase().contains(pattern) ?? false)) &&
          element.callmailstatus == listtype));
    } else {
      alltabs?[index] = data?.where((e) {
        return e.callmailstatus == listtype;
      }).toList();
    }
  }

  bool? isScrollable;
  sortdata() {
    data = _crmProvider.customers;

    tabs = _crmProvider.customertabs?.map((e) => e.name).toList();

    counts = _crmProvider.customertabs?.map((e) => e.count).toList();
    leadstabs = _crmProvider.leadstabs?.map((e) => e.name).toList() ?? [];
    alltabs = tabs?.map((key) {
      return data?.where((item) => item.callmailstatus == key).toList();
    }).toList();

    alldataLists = alltabs?.map((key) {
      return key
          ?.map((e) => {"clientid": e.userid, "isChecked": false})
          .toList();
    }).toList();

    selectall = alltabs?.map((e) => "Select all").toList();
  }

  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        // leading: ShimmerWidget.circular(radius: 60),
        title: ShimmerWidget.rectangular(
          width: MediaQuery.of(context).size.width / 2.1,
          height: 100,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  List<Customers>? data;
  List<String?> leadstabs = [];

  Future<bool> _showMyDialogcheck(
      context, currentTheme, count, totype, fromtype) async {
    bool? lst;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "${AppLocalizations.of(context).translate("Update_Cust_Status")}",
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                height: 80,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 60,
                        // width:MediaQuery.of(context).size.width/,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Text(
                            "${AppLocalizations.of(context).translate("ChangeStatus_Confirm")} ${count} Customer from ${fromtype}  to ${totype}...?"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      '${AppLocalizations.of(context).translate("No")}',
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = false);
                    },
                  ),
                  TextButton(
                    child: Text(
                      '${AppLocalizations.of(context).translate("Yes")}',
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = true);
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
    return lst!;
  }

  Future<bool> handleWillAccept(currentTheme, i) async {
    if (i != _tabController.index) {
      bool result = await _showMyDialogcheck(
        context,
        currentTheme,
        alldataLists![_tabController.index]
            ?.where((element) => element["isChecked"] == true)
            .toList()
            .length,
        tabs?[i],
        tabs?[_tabController.index],
      );

      if (result) {
        var lst = alldataLists?[_tabController.index]?.where((val) {
          return val["isChecked"] == true;
        }).toList();

        if (lst!.isNotEmpty) {
          var maillist = lst.map((mail) {
            return mail['clientid'];
          }).toList();
          context.loaderOverlay.show();

          await _crmProvider.changecuststatus(
            maillist,
            _userProvider.selectedworkspace?.branchid,
            tabs?[i],
          );

          await _crmProvider.getcustomertabs(
            _userProvider.selectedworkspace?.branchid,
          );

          await _crmProvider.getstackholdertypes(
            _userProvider.selectedworkspace?.branchid,
          );

          _crmProvider.customersdata(
            _userProvider.selectedworkspace?.branchid,
          );
        }
        context.loaderOverlay.hide();
      }
      ;

      return result; // Return result based on user confirmation
    }
    return true; // Default return value
  }

  Widget body(
      currentTheme, List<Customers>? names, dataList, listtype, index, select) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Center(
                    child: TextFormField(
                      onChanged: (text) {
                        onSearchTextChanged(text, names, listtype, index);
                      },
                      controller: search,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 20, left: 10), // add padding to adjust text
                          isDense: true,
                          hintText:
                              '${AppLocalizations.of(context).translate("common_search")}',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        var availableValue = value ?? '';
                        if (availableValue.isEmpty) {
                          return ("Enter Name!");
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    dataList.clear();
                    if (select == "Select all") {
                      setState(() {
                        selectall![index] = "Deselect all";
                        for (int i = 0; i < names!.length; i++) {
                          dataList.add(
                              {"email": names[i].email, "isChecked": true});
                        }
                      });
                    } else {
                      setState(() {
                        selectall![index] = "Select all";
                        for (int i = 0; i < names!.length; i++) {
                          dataList.add(
                              {"email": names[i].email, "isChecked": false});
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentTheme.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          '${AppLocalizations.of(context).translate("${select}")}',
                          style: currentTheme.textTheme.displayLarge
                              ?.copyWith(color: currentTheme.primaryColor)),
                    )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
            child: SingleChildScrollView(
              child: Column(children: [
                if (names!.isEmpty) ...[
                  Nodatafound(),
                  SizedBox(
                    height: 65,
                  ),
                ],
                ...names.map(
                  (e) => SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 12, left: 12, bottom: 8),
                      child: InkWell(
                        onTap: () {
                          // _showsubcatbottom(currentTheme, e.userid);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Singlecustomer(
                                  userid: e.userid,
                                  agentid: widget.agentid,
                                  productid: widget.productid,
                                  role: widget.role,
                                  // access: widget.access
                                ),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: currentTheme.canvasColor,
                              border: Border(
                                  bottom: BorderSide(
                                      color: currentTheme.primaryColor
                                          .withAlpha(178),
                                      width: 3)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Draggable(
                                      onDragStarted: () {
                                        if (dataList
                                                .where((val) {
                                                  return val["isChecked"] ==
                                                      true;
                                                })
                                                .toList()
                                                .length ==
                                            0) {
                                          setState(() {
                                            select = "Select all";
                                            dataList[names.indexOf(e)]
                                                    ["isChecked"] =
                                                !dataList[names.indexOf(e)]
                                                    ["isChecked"];
                                          });
                                        }
                                      },
                                      feedback: Container(
                                        width: 120,
                                        height: 60,
                                        color: const Color.fromARGB(
                                                255, 202, 200, 197)
                                            .withAlpha(127),
                                        child: Center(
                                          child: Text(
                                            "Move ${dataList.where((val) {
                                                  return val["isChecked"] ==
                                                      true;
                                                }).toList().length == 0 ? 1 : dataList.where((val) {
                                                  return val["isChecked"] ==
                                                      true;
                                                }).toList().length} Item's",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.none,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                              activeColor:
                                                  currentTheme.primaryColor,
                                              value: dataList[names.indexOf(e)]
                                                  ["isChecked"],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  //                                                   var lst=dataList.where((val){return val["isChecked"]=false;}).toList();
                                                  //                                                   if (lst.isNotEmpty) {
                                                  //   select="Select all";
                                                  // }else{
                                                  //   select="Deselect all";
                                                  // }
                                                  select = "Select all";
                                                  dataList[names.indexOf(e)]
                                                      ["isChecked"] = !dataList[
                                                          names.indexOf(e)]
                                                      ["isChecked"];
                                                });
                                              }),
                                          if (e.name != null) ...[
                                            Text(
                                              e.name!.length < 34
                                                  ? e.name!
                                                  : e.name!.split(' ')[0],
                                              // softWrap: true,,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,

                                              style: currentTheme
                                                  .textTheme.displayLarge
                                                  ?.copyWith(
                                                      color: currentTheme
                                                          .primaryColor),
                                            )
                                          ],
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditContact(
                                                      edit: true,
                                                      appbarname:
                                                          "${AppLocalizations.of(context).translate("Edit_Contact")}",
                                                      userid: e.userid!,
                                                      actiontype: e.actiontype,
                                                      addressline1: e.address,
                                                      customertype:
                                                          e.customertype,
                                                      email: e.email,
                                                      lastmsged: e.lastmsged,
                                                      name: e.name,
                                                      nextmsgdate:
                                                          e.nextmsgdate,
                                                      phone: e.phone,
                                                      stakeholdertype:
                                                          "Customers",
                                                    ),
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blueGrey,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //     padding:
                              //         const EdgeInsets.only(bottom: 5.0, left: 15),
                              //     child: Align(
                              //       alignment: Alignment.topLeft,
                              //       child: Text(
                              //         e.productnames!.join(" , ").toString(),

                              //         style: currentTheme.textTheme.displayMedium,
                              //       ),
                              //     )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            e.email ?? '',
                                            style: currentTheme
                                                .textTheme.bodyLarge,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            e.phone ?? '',
                                            style: currentTheme
                                                .textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${AppLocalizations.of(context).translate("Nextmsgdate")}",
                                            style: currentTheme
                                                .textTheme.bodySmall,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            e.nextmsgdate ?? "",
                                            style: currentTheme
                                                .textTheme.bodyLarge,
                                          ),
                                        ],
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
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentTheme.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 12, top: 12),
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context).translate("MoveToContacts")}",
                            style: TextStyle(
                                color: currentTheme.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          var lst = dataList.where((val) {
                            return val["isChecked"] == true;
                          }).toList();

                          if (lst.isNotEmpty) {
                            var maillist = lst.map((mail) {
                              return mail['clientid'];
                            }).toList();

                            context.loaderOverlay.show();
                            await _crmProvider.updatestack(
                                'Contacts',
                                _userProvider.selectedworkspace?.branchid,
                                maillist,
                                '');

                            await _crmProvider.getcustomertabs(
                              _userProvider.selectedworkspace?.branchid,
                            );
                            await _crmProvider.getstackholdertypes(
                              _userProvider.selectedworkspace?.branchid,
                            );

                            context.loaderOverlay.hide();

                            _crmProvider.customersdata(
                              _userProvider.selectedworkspace?.branchid,
                            );
                            _crmProvider.contactsdata(
                              _userProvider.selectedworkspace?.branchid,
                            );
                          } else {
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Please select customers"),
                                backgroundColor: Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentTheme.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 12, top: 12),
                      child: InkWell(
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context).translate("MoveToLeads")}",
                            style: TextStyle(
                                color: currentTheme.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          var lst = dataList.where((val) {
                            return val["isChecked"] == true;
                          }).toList();

                          if (lst.isNotEmpty) {
                            var maillist = lst.map((mail) {
                              return mail['clientid'];
                            }).toList();
                            var selecttab = await _showMyDialog(
                                context,
                                currentTheme,
                                leadstabs,
                                leadstabs.first,
                                'Leads');

                            if (selecttab[0]) {
                              context.loaderOverlay.show();
                              await _crmProvider.updatestack(
                                  'Leads',
                                  _userProvider.selectedworkspace?.branchid,
                                  maillist,
                                  selecttab[1]);

                              await _crmProvider.getcustomertabs(
                                _userProvider.selectedworkspace?.branchid,
                              );
                              await _crmProvider.getstackholdertypes(
                                _userProvider.selectedworkspace?.branchid,
                              );
                              _crmProvider.customersdata(
                                _userProvider.selectedworkspace?.branchid,
                              );
                              _crmProvider.leadsdata(
                                _userProvider.selectedworkspace?.branchid,
                              );
                              _crmProvider.getleadstabs(
                                _userProvider.selectedworkspace?.branchid,
                              );
                              context.loaderOverlay.hide();
                            }
                          } else {
                            final snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                    "${AppLocalizations.of(context).translate("Pls_select_cust")}"),
                                backgroundColor: Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
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
                    var lst = dataList.where((val) {
                      return val["isChecked"] == true;
                    }).toList();
                    if (lst.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseTemplate(
                              emails: lst.map((w) => w['email']).toList(),
                            ),
                          ));
                    } else {
                      const snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text("Please select customers"),
                          backgroundColor: Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  late final TabController _tabController;
  TextEditingController search = TextEditingController();

  late Userprovider _userProvider;
  late Crmprovider _crmProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    _crmProvider = context.watchcrm;

    if (data == null || data!.isEmpty) {
      sortdata();
    }
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  "${AppLocalizations.of(context).translate("Customers")}"),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              )),
              backgroundColor: currentTheme.primaryColor,
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  isScrollable: isScrollable ?? false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  controller: _tabController,
                  tabs: <Widget>[
                    for (var i = 0; i < tabs!.length; i++) ...[
                      DragTarget(onWillAccept: (data) {
                        if (i != _tabController.index) {
                          final completer = Completer<bool>();
                          handleWillAccept(currentTheme, i).then((result) {
                            print("Completer Result: $result");

                            completer.complete(result);
                          });
                        }
                        return true; // Ensure this is always true
                      }, builder: (context, candidateData, rejectedData) {
                        return Tab(
                          text: '${tabs?[i]} - ${counts?[i]}',
                        );
                      })
                    ]
                  ]),
            ),
            body: _crmProvider.getcustomerdata
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        ...List.generate(3, (int index) => loader())
                      ],
                    ),
                  )
                : TabBarView(controller: _tabController, children: [
                    for (int i = 0; i < alltabs!.length; i++) ...[
                      SingleChildScrollView(
                        child: body(currentTheme, alltabs![i], alldataLists![i],
                            tabs![i], i, selectall![i]),
                      ),
                    ]
                  ])));
  }
}
