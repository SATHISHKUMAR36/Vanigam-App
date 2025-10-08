import 'package:crm_generatewealthapp/common/commondropdown.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/filter_chip_data.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UsermanagementAction extends StatefulWidget {
  bool edit;
  String? defname;
  List<Map<String, dynamic>>? companynames;

  UsermanagementAction(
      {super.key, required this.edit, this.defname, this.companynames});

  @override
  State<UsermanagementAction> createState() => _UsermanagementActionState();
}

class _UsermanagementActionState extends State<UsermanagementAction> {
  void initState() {
    super.initState();

    // working list (can be modified by checkboxes)
    companies = widget.companynames != null
        ? widget.companynames!.map((e) => Map<String, dynamic>.from(e)).toList()
        : [];

    // snapshot of the original data (never touched)
    oldcompanies = widget.companynames != null
        ? widget.companynames!.map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
  }

  late Userprovider _userprovider;
  late ThemeData currentTheme;

  List<Map<String, dynamic>>? companies;
  List<Map<String, dynamic>>? oldcompanies;

  String? def_emp;

  List<FilterChipData>? filterChips;

  Widget buildFilterchips(ThemeData currentTheme) {
    return Wrap(
      // runSpacing: 8,
      spacing: 8,
      children: filterChips!
          .map((filterChip) => FilterChip(
                label: Text(filterChip.label),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentTheme.primaryColor,
                ),
                backgroundColor: Colors.grey.withOpacity(0.2),
                onSelected: (isSelected) => setState(() {
                  filterChips = filterChips!.map((otherChip) {
                    return filterChip == otherChip
                        ? otherChip.copy(isSelected: isSelected)
                        : otherChip;
                  }).toList();
                }),
                selected: filterChip.isSelected,
                //  checkmarkColor: currentTheme.primaryColor,
                selectedColor:
                    currentTheme.colorScheme.primary.withOpacity(0.4),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> buildPayload() {
    final adds = <Map<String, dynamic>>[];
    final updates = <Map<String, dynamic>>[];
    final deletes = <Map<String, dynamic>>[];
    final workspaceAdds = <Map<String, dynamic>>[];
    final workspaceDeletes = <Map<String, dynamic>>[];

    final oldByBranch = {for (var b in oldcompanies ?? []) b["BranchID"]: b};
    final newByBranch = {for (var b in companies ?? []) b["BranchID"]: b};

    // Check new
    for (var nb in companies ?? []) {
      final ob = oldByBranch[nb["BranchID"]];
      final newSelected = nb["ISCRM"] == true || nb["ISAccounting"] == true;
      final oldSelected =
          ob != null && (ob["ISCRM"] == true || ob["ISAccounting"] == true);

      if (!oldSelected && newSelected) {
        adds.add(nb);
        // workspace add (if workspace didn't exist before)
        final wsExisted = oldcompanies?.any(
          (b) =>
              b["WorkspaceID"] == nb["WorkspaceID"] &&
              (b["ISCRM"] == true || b["ISAccounting"] == true),
        );

        if (!(wsExisted ?? true)) {
          workspaceAdds.add({
            "WorkspaceID": nb["WorkspaceID"],
            // "branches": [nb]
          });
        }
      } else if (oldSelected && newSelected) {
        if (ob!["ISCRM"] != nb["ISCRM"] ||
            ob["ISAccounting"] != nb["ISAccounting"]) {
          updates.add(nb);
        }
      }
    }

    // Check deletes
    for (var ob in oldcompanies ?? []) {
      final nb = newByBranch[ob["BranchID"]];
      final oldSelected = ob["ISCRM"] == true || ob["ISAccounting"] == true;
      final newSelected =
          nb != null && (nb["ISCRM"] == true || nb["ISAccounting"] == true);

      if (oldSelected && !newSelected) {
        deletes.add(ob);
      }
    }

    // // Workspace deletes
    // final groupedOld = <String, List<Map<String, dynamic>>>{};
    // for (var b in oldcompanies ?? []) {
    //   groupedOld.putIfAbsent(b["WorkspaceID"], () => []).add(b);
    // }
    // for (var wsId in groupedOld.keys) {
    //   final hasRemaining = companies?.any((b) =>
    //       b["WorkspaceID"] == wsId &&
    //       (b["ISCRM"] == true || b["ISAccounting"] == true));
    //   if (!(hasRemaining ?? true)) {
    //     workspaceDeletes.add({"WorkspaceID": wsId});
    //   }
    // }

    // Workspace deletes
    final groupedOld = <String, List<Map<String, dynamic>>>{};
    for (var b in oldcompanies ?? []) {
      groupedOld.putIfAbsent(b["WorkspaceID"], () => []).add(b);
    }

    for (var wsId in groupedOld.keys) {
      // check if old workspace had at least one selected branch
      final hadSelectedBefore = groupedOld[wsId]!.any(
        (b) => b["ISCRM"] == true || b["ISAccounting"] == true,
      );

      if (hadSelectedBefore) {
        // check if new still has any selected
        final hasRemaining = companies?.any(
          (b) =>
              b["WorkspaceID"] == wsId &&
              (b["ISCRM"] == true || b["ISAccounting"] == true),
        );

        if (!(hasRemaining ?? false)) {
          workspaceDeletes.add({"WorkspaceID": wsId});
        }
      }
    }

    return {
      "workspaceAdds": workspaceAdds,
      "branchAdds": adds,
      "branchUpdates": updates,
      "branchDeletes": deletes,
      "workspaceDeletes": workspaceDeletes,
    };
  }

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    currentTheme = context.watchtheme.currentTheme;
    if (def_emp == null && widget.defname == null) {
      def_emp = _userprovider.untagged_employeenames.first ?? '';
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Color.fromARGB(255, 74, 63, 221),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //   height: 15,
              // ),
              // CircleAvatar(
              //   child: Icon(
              //     Icons.manage_accounts,
              //     color: Colors.indigo,
              //   ),
              //   backgroundColor: Colors.indigo[50],
              //   radius: 30,
              // ),
              // Image.asset(
              //   "assets/images/usermanagment.png",
              //   height: 150,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo, width: 1)),
                    child: Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      // Divider(
                      //   thickness: 2,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).translate("Employee"),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      // Divider(thickness: 0.3,),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CommonDropdown(
                            hidedropdown: !widget.edit,
                            items: _userprovider.untagged_employeenames ?? [],
                            hintText: "Select Employee",
                            selectedValue: widget.defname ?? def_emp,
                            onChanged: (value) {
                              setState(() {
                                def_emp = value!;
                              });
                            },
                            itemAsString: (item) => item),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate("UserManagement_userrole"),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                def_emp != null
                                    ? _userprovider.nouseremployee
                                            ?.where((element) =>
                                                "${element.FirstName} ${element.LastName}" ==
                                                def_emp)
                                            .first
                                            .EmployeeType ??
                                        ''
                                    : _userprovider.Employees?.where((element) =>
                                            "${element.FirstName} ${element.LastName}" ==
                                            widget
                                                .defname).first.EmployeeType ??
                                        '',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).translate("Company"),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      // buildFilterchips(currentTheme),

                      ...companies!.map(
                        (e) => Column(children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      e["BranchName"].toString(),
                                      style: currentTheme
                                          .textTheme.displayMedium
                                          ?.copyWith(
                                              color: const Color.fromARGB(
                                                  255, 44, 69, 216)),
                                    ),
                                    //     ...companies?[e].map((access) {
                                    //       return Row(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           Checkbox(
                                    //             value: companies?[e]![access],
                                    //             onChanged: (val) {
                                    //               setState(() {
                                    //                 companies?[e] != val!;
                                    //               });
                                    //             },
                                    //           ),
                                    //           Text(access),
                                    //         ],
                                    //       );
                                    //     }).toList(),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  if (e["ISCRM"] != null)
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.indigo,
                                          value: e["ISCRM"] ?? false,
                                          onChanged: (val) {
                                            setState(() {
                                              e["ISCRM"] = val;
                                            });
                                          },
                                        ),
                                        Text("CRM"),
                                      ],
                                    ),
                                  if (e["ISAccounting"] != null)
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.indigo,
                                          value: e["ISAccounting"] ?? false,
                                          onChanged: (val) {
                                            setState(() {
                                              e["ISAccounting"] = val;
                                            });
                                          },
                                        ),
                                        Text("Accounting"),
                                      ],
                                    ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          )
                          // Row(children: [
                          //   ...companies?[e].entries.map((br) => Row(
                          //         children: [
                          //           Checkbox(
                          //             value: br.value,
                          //             activeColor: Colors.indigo,
                          //             onChanged: (val) {
                          //               setState(() {
                          //                 companies?[e]![br.key] = val!;
                          //               });
                          //             },
                          //           ),
                          //           Text(br.key),
                          //         ],
                          //       ))
                          // ])
                          // ]),
                        ]),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      InkWell(
                        onTap: () async {
                          final anySelectedNew = companies?.any(
                            (b) =>
                                b["ISCRM"] == true || b["ISAccounting"] == true,
                          );
                          bool same = true;
                          final oldByBranch = {
                            for (var b in oldcompanies ?? []) b["BranchID"]: b
                          };
                          if ((oldcompanies?.length ?? 0) !=
                              (companies?.length ?? 0)) {
                            same = false;
                          } else {
                            for (var nb in companies ?? []) {
                              final ob = oldByBranch[nb["BranchID"]];
                              if (ob == null ||
                                  ob["ISCRM"] != nb["ISCRM"] ||
                                  ob["ISAccounting"] != nb["ISAccounting"]) {
                                same = false;
                                break;
                              }
                            }
                          }
                          if (!(anySelectedNew ?? false)) {
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text("Please select any one feature"),
                                backgroundColor: Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (same) {
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text("Please make changes"),
                                backgroundColor: Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          // print(companies);
                          // print(groupBy(companies!, (e) => e["WorkspaceID"]));
                          // _usermanaging(context, false);
                          else {
                            var jsonout = buildPayload();

                            print(jsonout);

                            if (!widget.edit) {
                              var Emp = _userprovider.nouseremployee!
                                  .where((e) =>
                                      "${e.FirstName} ${e.LastName}" == def_emp)
                                  .toList();

                              context.loaderOverlay.show();

                              bool out =
                                  await _userprovider.usermangementaction(
                                      !widget.edit,
                                      false,
                                      null,
                                      jsonout,
                                      Emp.first.EmailID,
                                      Emp.first.EmployeeType,
                                      Emp.first.PhoneNumber,
                                      Emp.first.FirstName,
                                      Emp.first.LastName,
                                      Emp.first.ID);
                              context.loaderOverlay.hide();
                              if (out) {
                                final snackBar = SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                        "${AppLocalizations.of(context).translate("Success")}"),
                                    backgroundColor: Colors.green);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                        "${AppLocalizations.of(context).translate("Failed")}"),
                                    backgroundColor: Colors.red);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              var Emp = _userprovider
                                  .Employee_selectedworkspace!
                                  .where((e) =>
                                      "${e.FirstName} ${e.LastName}" ==
                                      widget.defname)
                                  .toList();
                              context.loaderOverlay.show();

                              if (Emp.first.EmailID != null &&
                                  Emp.first.EmailID!.isNotEmpty &&
                                  Emp.first.PhoneNumber != null &&
                                  Emp.first.PhoneNumber!.isNotEmpty) {
                                bool out =
                                    await _userprovider.usermangementaction(
                                        !widget.edit,
                                        false,
                                        Emp.first.UserID,
                                        jsonout,
                                        Emp.first.EmailID,
                                        Emp.first.EmployeeType,
                                        Emp.first.PhoneNumber,
                                        Emp.first.FirstName,
                                        Emp.first.LastName,
                                        Emp.first.ID);
                                context.loaderOverlay.hide();
                                if (out) {
                                  const snackBar = SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Success"),
                                      backgroundColor: Colors.green);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  const snackBar = SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Failed"),
                                      backgroundColor: Colors.red);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } else {
                                const snackBar = SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                        "Employee Email and Phone No is Mandatory for  create User..!"),
                                    backgroundColor: Colors.red);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, bottom: 20, left: 10, top: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.indigo),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context).translate("Save"),
                                style: currentTheme.textTheme.displayMedium
                                    ?.copyWith(
                                        color: Colors.white, fontSize: 16),
                              ),
                            )),
                          ),
                        ),
                      ),
                    ])),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
