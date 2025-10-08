import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/CRM/customer/customermodel.dart';
import 'package:crm_generatewealthapp/CRM/customer/edit_customer.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaCustomers extends StatefulWidget {
  const CaCustomers({super.key});

  @override
  State<CaCustomers> createState() => _CaCustomersState();
}

class _CaCustomersState extends State<CaCustomers> {
  List<Customers>? names;
  List<Map<String, dynamic>> dataList = [];
  List<Customers>? data;
  onSearchTextChanged(String text) {
    var pattern = text.toLowerCase();
    if (pattern.isNotEmpty) {
      names = [];
      names!.addAll(data!.where((element) =>
          element.name!.toLowerCase().contains(pattern) ||
          element.email!.toLowerCase().contains(pattern) ||
          element.tag!.toLowerCase().contains(pattern)));
    } else {
      names = data;
    }

    if (mounted) setState(() {});
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

  String select = "Select all";
  TextEditingController search = TextEditingController();

  sortdata() {
    data = _crmProvider.customers;
    names = data;
    for (int i = 0; i < data!.length; i++) {
      dataList.add({"email": data?[i].email, "isChecked": false});
    }
  }

  late Crmprovider _crmProvider;
  @override
  Widget build(BuildContext context) {
    _crmProvider = context.watchcrm;
    if (names == null) {
      sortdata();
    }
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("CA Customers"),
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Center(
                    child: TextFormField(
                      onChanged: onSearchTextChanged,
                      controller: search,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 20, left: 10), // add padding to adjust text
                          isDense: true,
                          hintText: 'Search',
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
                        select = "Deselect all";
                        for (int i = 0; i < data!.length; i++) {
                          dataList.add(
                              {"email": data?[i].email, "isChecked": true});
                        }
                      });
                    } else {
                      setState(() {
                        select = "Select all";
                        for (int i = 0; i < data!.length; i++) {
                          dataList.add(
                              {"email": data?[i].email, "isChecked": false});
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        color: currentTheme.primaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(select,
                            style: currentTheme.textTheme.displayLarge
                                ?.copyWith(color: currentTheme.primaryColor))),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ...names!.map(
              (e) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // _showsubcatbottom(currentTheme, e.userid);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Singlecustomer(userid: e.userid,),));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: currentTheme.canvasColor,
                          border: Border(
                              left: BorderSide(
                                  color: color(e.customertype), width: 2.5)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: currentTheme.primaryColor,
                                        value: dataList[names!.indexOf(e)]
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
                                            dataList[names!.indexOf(e)]
                                                    ["isChecked"] =
                                                !dataList[names!.indexOf(e)]
                                                    ["isChecked"];
                                          });
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        e.name ?? "",
                                        style: currentTheme
                                            .textTheme.displayLarge
                                            ?.copyWith(
                                                color:
                                                    currentTheme.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        height: 30,
                                        width: 110,
                                        decoration: BoxDecoration(
                                            color: color(e.customertype)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            e.customertype ?? '',
                                            style: currentTheme
                                                .textTheme.displayMedium
                                                ?.copyWith(
                                                    color:
                                                        color(e.customertype)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCustomer(
                                                  userid: e.userid!,
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
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, left: 15),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  e.productnames!.join(" , ").toString(),
                                  style: currentTheme.textTheme.displayMedium,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      e.email ?? '',
                                      style: currentTheme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      e.phone!,
                                      style: currentTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Last Messaged",
                                      style: currentTheme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      e.lastmsged ?? "",
                                      style: currentTheme.textTheme.bodyLarge,
                                    ),
                                  ],
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
          ],
        ),
      ),
    ));
  }
}
