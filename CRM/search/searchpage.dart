import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/constant.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/CRM/contact/edit_contact.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/CRM/search/searchmodel.dart';
import 'package:crm_generatewealthapp/CRM/search/singlesearch.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Searchpage extends StatefulWidget {
  String? productid;

  Searchpage({super.key, this.productid});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  TextEditingController _textcontroller = TextEditingController();

  late Userprovider _userprovider;
    late Crmprovider _crmProvider;

  searchbutton(currentTheme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorColor: Colors.white,
            style: currentTheme.textTheme.displaySmall!
                .copyWith(color: Colors.white),
            autofocus: true,
            controller: _textcontroller,
            decoration: InputDecoration(
              hintText:
                  '${AppLocalizations.of(context).translate("type_search")}',
              hintStyle: currentTheme.textTheme.displaySmall!
                  .copyWith(color: Colors.grey),
              border: InputBorder.none,
            ),
            onChanged: onSearchTextChanged,
          ),
        ),
      ],
    );
  }

  onSearchTextChanged(String text) {
    var pattern = text.toLowerCase();
    if (pattern.isNotEmpty) {
      names = [];
      names!.addAll(data!.where((element) =>
          element.name!.toLowerCase().contains(pattern) ||
          element.email!.toLowerCase().contains(pattern)));
    } else {
      names = data;
    }

    if (mounted) setState(() {});
  }

  List<Searchmodel>? data;
  List<Searchmodel>? names;
  List<Map<String, dynamic>> dataList = [];

  sortdata() {
    data = _crmProvider.searchdata;

    names = data;
    if (data != null) {
      for (int i = 0; i < data!.length; i++) {
        dataList.add({"clientid": data?[i].userid, "isChecked": false});
      }
    }
  }

  color(data) {
    switch (data) {
      case 'Contacts':
        return Colors.pink;
      case 'Leads':
        return Colors.blue;
      case 'Customers':
        return Colors.green;
      default:
        return Colors.deepPurple;
    }
  }

  Widget bodydata(currentTheme) {
    return SingleChildScrollView(
      child: Column(children: [
        if (names!.isEmpty) ...[
          Nodatafound(),
          SizedBox(
            height: 65,
          ),
        ],
        SizedBox(
          height: 15,
        ),
        ...?names?.map(
          (e) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
              child: InkWell(
                onTap: () {
                  // _showsubcatbottom(currentTheme, e.userid);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Singlesearch(
                          userid: e.userid,
                          agentid: _userprovider.userdata?.agentid,
                          productid: widget.productid,
                          role: _userprovider.userdata?.role,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: currentTheme.canvasColor,
                      border: Border(
                          bottom: BorderSide(
                              color: currentTheme.primaryColor.withAlpha(178),
                              width: 3)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              // Checkbox(
                              //     activeColor:
                              //         currentTheme.primaryColor,
                              //     value: dataList[names!
                              //         .indexOf(e)]["isChecked"],
                              //     onChanged: (bool? value) {
                              //       setState(() {
                              //         //                                                   var lst=dataList.where((val){return val["isChecked"]=false;}).toList();
                              //         //                                                   if (lst.isNotEmpty) {
                              //         //   select="Select all";
                              //         // }else{
                              //         //   select="Deselect all";
                              //         // }
                              //         select = "Select all";
                              //         dataList[names!
                              //                     .indexOf(e)]
                              //                 ["isChecked"] =
                              //             !dataList[names!
                              //                     .indexOf(e)]
                              //                 ["isChecked"];

                              //         var selected =
                              //             dataList.where((val) {
                              //           return val[
                              //                   "isChecked"] ==
                              //               true;
                              //         }).toList();
                              //         count = selected.length;
                              //       });
                              //     }),
                              if (e.name != null) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      e.name!.length < 34
                                          ? e.name!
                                          : e.name!.split(' ')[0],
                                      // softWrap: true,,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,

                                      style: currentTheme.textTheme.displayLarge
                                          ?.copyWith(
                                              color: currentTheme.primaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    e.stackholdertype ?? '',
                                    style: TextStyle(
                                        color: color(e.stackholdertype ?? '')),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditContact(
                                              edit: true,
                                              appbarname: "Edit Data",
                                              userid: e.userid!,
                                              actiontype: e.actiontype,
                                              addressline1: e.address,
                                              customertype: e.customertype,
                                              email: e.email,
                                              lastmsged: e.lastmsged,
                                              name: e.name,
                                              nextmsgdate: e.nextmsgdate,
                                              phone: e.phone,
                                              stakeholdertype:
                                                  e.stackholdertype,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    e.email ?? '',
                                    style: currentTheme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    e.phone ?? '',
                                    style: currentTheme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context).translate("Nextmsgdate")}",
                                    style: currentTheme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    e.nextmsgdate ?? "",
                                    style: currentTheme.textTheme.bodyLarge,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userprovider = context.watchuser;
        _crmProvider = context.watchcrm;

    if (data == null || data!.isEmpty) {
      sortdata();
    }

    return _crmProvider.getalldata
        ? Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: currentTheme.primaryColor,
            ),
            body: circleLoader(context))
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 2,
                automaticallyImplyLeading: true,
                title: searchbutton(currentTheme),
                backgroundColor: currentTheme.primaryColor,
              ),
              resizeToAvoidBottomInset: false,
              body: bodydata(currentTheme),
            ),
          );
  }
}
