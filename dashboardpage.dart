import 'package:crm_generatewealthapp/Accounting/accounting_dashboard.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/CRM/landingpage.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/models/tenant_model.dart';
import 'package:crm_generatewealthapp/models/workspace_model.dart';
import 'package:crm_generatewealthapp/profilepage.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Userprovider _userprovider;
  late ThemeData currentTheme;
  late TenantModel? _selectedtenant;
  @override
  void initState() {
    super.initState();
  }

  _getwstitles() {
    if (_userprovider.groupedworkspace != null)
      return _userprovider.groupedworkspace!.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         color: Colors.grey[200],
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 16.0, vertical: 6.0),
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.work,
            //               size: 20,
            //               color: Colors.black54,
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Expanded(
            //               child: Text(entry.value.first.workspacename ?? '',
            //                   overflow: TextOverflow.ellipsis,
            //                   maxLines: 1,
            //                   softWrap: false,
            //                   style: const TextStyle(
            //                       fontSize: 14,
            //                       color: Colors.black87,
            //                       fontWeight: FontWeight.bold,
            //                       height: 1,
            //                       letterSpacing: 1)),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            ...entry.value.map((workspace) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkWell(
                    onTap: () {
                      _userprovider.setselectedworkspace(workspace);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: _userprovider.selectedworkspace == workspace
                          ? BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 74, 63, 221).withAlpha(75),
                                Color.fromARGB(255, 74, 63, 221).withAlpha(102),
                                Color.fromARGB(255, 74, 63, 221).withAlpha(127),
                              ]),
                            )
                          : null,
                      padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(workspace.branchname ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        );
      });
    return [Container()];
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 74, 63, 221)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${AppLocalizations.of(context).translate("Hi")}, ${_selectedtenant?.tenantname ?? ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1,
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(_selectedtenant?.userrole ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                        )),
                  ],
                ),
              ],
            ),
          ),
          if (_userprovider.iswsfetching) ...[
            ShimmerWidget.rectangular(
              width: MediaQuery.of(context).size.width / 2.1,
              height: 20,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            ShimmerWidget.rectangular(
              width: MediaQuery.of(context).size.width / 2.1,
              height: 20,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            )
          ],
          if (!_userprovider.iswsfetching) ..._getwstitles()
        ],
      ),
    );
  }

  _dropdownbutton() {
    final List<TenantModel> menuItems = _userprovider.tenants;
    if (menuItems.length > 1)
      return DropdownButtonHideUnderline(
        child: DropdownButton2<TenantModel>(
          isExpanded: true,
          isDense: true,
          hint: Text("Select business"),
          dropdownStyleData: DropdownStyleData(
            offset: Offset(0, -10), // Show dropdown 5px below the button
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            iconSize: 24,
          ),
          value: _selectedtenant,
          onChanged: (TenantModel? value) {
            setState(() {
              if (value != null) {
                _userprovider.setselectedtenant(value);
              }
            });
          },
          items: menuItems.map((e) {
            return DropdownMenuItem<TenantModel>(
              value: e,
              child: Text(e.tenantname ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return menuItems.map((e) {
              return Text(
                e.tenantname ?? '',
                style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      );
    else
      return SizedBox.shrink();
  }

  _gotoapp(Features features) {
    if (features == Features.Accounting) {
      context.readaccounts.fetchalldata(
          _userprovider.selectedtenant?.tenantid,
          _userprovider.selectedworkspace?.workspaceid,
          _userprovider.selectedworkspace?.branchid);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountingDashboard(
                    BranchID: _userprovider.selectedworkspace?.branchid,
                    TenantID: _userprovider.selectedtenant?.tenantid,
                    WorkspaceID: _userprovider.selectedworkspace?.workspaceid,
                  )));
    } else if (features == Features.CRM) {
      context.readcrm
          .fetchalldata(context.readuser.selectedworkspace?.branchid);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Landingpage()));
    }
  }

  _getbody() {
    if (_userprovider.workspaces.isNotEmpty) {
      if (_userprovider.selectedworkspace != null)
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 20,
                      color: Color.fromARGB(255, 74, 63, 221),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                          //'${_userprovider.selectedworkspace!.workspacename} > ${_userprovider.selectedworkspace!.branchname}',
                          '${_userprovider.selectedworkspace!.branchname}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 74, 63, 221),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_userprovider.selectedworkspace!.featuresenabled.isNotEmpty)
                  ..._userprovider.selectedworkspace!.featuresenabled
                      .map((feature) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: InkWell(
                        onTap: () {
                          _gotoapp(feature);
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                      height: 100,
                                      width: 100,
                                      feature.imagelink),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    feature.displaytitle == "Accounting"
                                        ? '${AppLocalizations.of(context).translate("Accounting")}'
                                        : feature.displaytitle,
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        height: 1,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ));
                  }),
                if (_userprovider
                    .selectedworkspace!.featuresenabled.isEmpty) ...[
                  RefreshIndicator(
                      onRefresh: () async {
                        await _userprovider.fetchworkspaces();
                      },
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/ndf.png",
                                  height: 200,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text(
                                    '${AppLocalizations.of(context).translate("NoFeatureEnabled")}',
                                    style: TextStyle(fontSize: 14, height: 1.5),
                                  ),
                                )
                              ],
                            ),
                          )))
                ]
              ],
            ),
          ),
        );
      else {
        return Column(
          children: [
            Text(
                "${AppLocalizations.of(context).translate("SelectWorkSpace")}"),
          ],
        );
      }
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await _userprovider.fetchworkspaces();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Image.asset(
                  "assets/images/ndf.png",
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'No Workspaces found for the selected Organization',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  _alertdialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              surfaceTintColor: currentTheme.splashColor,
              content: Text(
                "${AppLocalizations.of(context).translate("ExitApplication")}",
                style: currentTheme.textTheme.bodyMedium,
              ),
              title: Text(
                "${AppLocalizations.of(context).translate("ExitApp")}",
                style: currentTheme.textTheme.bodySmall,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('NO',
                      style:
                          TextStyle(color: Color.fromARGB(255, 193, 36, 233))),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: const Text('YES',
                      style:
                          TextStyle(color: Color.fromARGB(255, 193, 36, 233))),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userprovider = context.watchuser;
    _selectedtenant = _userprovider.selectedtenant ??
        (_userprovider.tenants.isNotEmpty ? _userprovider.tenants.first : null);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: _dropdownbutton(),
        backgroundColor: Color.fromARGB(255, 74, 63, 221),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  icon: Icon(Icons.person_2_outlined)),
            ],
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: _userprovider.iswsfetching
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerWidget.rectangular(
                height: 200,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            )
          : PopScope(
              canPop: false,
              onPopInvoked: (didpop) async {
                if (didpop) {
                  return;
                }
                _alertdialog(context);
              },
              child: _getbody(),
            ),
      backgroundColor: currentTheme.canvasColor,
    ));
  }
}
