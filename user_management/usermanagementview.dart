import 'package:crm_generatewealthapp/Accounting/models/EmployeeModel.dart';
import 'package:crm_generatewealthapp/common/commondropdown.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/filter_chip_data.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:crm_generatewealthapp/user_management/usermanagementaction.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late Userprovider _userprovider;
  late ThemeData currentTheme;

  String? def_emp;
  MultiSelectController<String> _controller = MultiSelectController();

  Future<bool> _usermanaging(BuildContext context, bool edit,
      {List<DropdownItem<String>>? additems, defname}) async {
    if (edit) {
      _controller.clearAll();

      _controller.addItems(additems!);
    }
    bool out = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
                surfaceTintColor: currentTheme.splashColor,
                content: SizedBox(
                  // height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Employee",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                      // Divider(thickness: 0.3,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonDropdown(
                            hidedropdown: !edit,
                            items: _userprovider.untagged_employeenames ?? [],
                            hintText: "Select Employee",
                            selectedValue: defname ?? def_emp,
                            onChanged: (value) {
                              setState(() {
                                def_emp = value!;
                              });
                            },
                            itemAsString: (item) => item),
                      ),
                      Divider(
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Company's ",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                      MultiDropdown<String>(
                        controller: _controller,
                        items: _userprovider.workspaces
                            .map((emp) => DropdownItem<String>(
                                  label: "${emp.branchname}",
                                  value: emp.branchid!,
                                ))
                            .toList(),
                        chipDecoration: ChipDecoration(
                          backgroundColor: Colors.grey[100],
                          border: Border.all(color: Colors.indigo),
                          wrap: true,
                        ),
                        fieldDecoration: const FieldDecoration(
                          border: UnderlineInputBorder(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                              color:
                                  Colors.grey, // Customize the underline color
                            ),
                          ),
                          hintText: "Select companies",
                          showClearIcon: true,
                          // border: OutlineInputBorder(),
                        ),
                        dropdownDecoration: DropdownDecoration(
                          maxHeight: 300,
                          footer: ElevatedButton(
                            onPressed: () {
                              // closes the overlay by unfocusing
                              // FocusScope.of(context).unfocus();
                              _controller.closeDropdown();
                              // Navigator.of(context).pop();
                            },
                            child: const Text("Done"),
                          ),
                        ),
                        onSelectionChange: (selected) {
                          print("Selected companies IDs: $selected");
                          // FocusScope.of(context).unfocus();
                          // Navigator.of(context).pop();
                        },
                      ),
                      // const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     print(
                      //         "Final selected IDs: ${_controller.selectedItems}");
                      //   },
                      //   child: const Text("Get Selected"),
                      // ),
                      Divider(
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "User Management",
                  style: currentTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close',
                        style: TextStyle(
                            color: Color.fromARGB(255, 193, 36, 233))),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  TextButton(
                    child: const Text('Save',
                        style: TextStyle(
                            color: Color.fromARGB(255, 193, 36, 233))),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ]),
          );
        });
    return out ?? false;
  }

  Future<bool> _showMyDialogdelete(context, currentTheme) async {
    bool? lst = false;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context)
                  .translate("UserManagement_deletetitle"),
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SizedBox(
              height: 75,
              child: Column(
                children: [
                  Text(
                      AppLocalizations.of(context)
                          .translate("UserManagement_deletedesc"),
                      style: TextStyle(height: 1.3))
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context).translate("No"),
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = false);
                    },
                  ),
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context).translate("Yes"),
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
    return lst ?? false;
  }

  Map<String, dynamic> buildDeleteAllPayload(
      List<Map<String, dynamic>> oldcompanies) {
    final deletes = <Map<String, dynamic>>[];
    final workspaceDeletes = <Map<String, dynamic>>[];

    // Delete all branches
    final groupedOldbr = <String, List<Map<String, dynamic>>>{};
    for (var b in oldcompanies) {
      final newSelected = b["ISCRM"] == true || b["ISAccounting"] == true;

      if (newSelected) {
        deletes.add(b);
      }
    }

    // Delete all workspaces (unique IDs)
    final groupedOld = <String, List<Map<String, dynamic>>>{};
    for (var b in oldcompanies) {
      groupedOld.putIfAbsent(b["WorkspaceID"], () => []).add(b);
    }

    workspaceDeletes.addAll(
      groupedOld.keys.map((wsId) => {"WorkspaceID": wsId}),
    );

    return {
      "workspaceAdds": [],
      "branchAdds": [],
      "branchUpdates": [],
      "branchDeletes": deletes,
      "workspaceDeletes": workspaceDeletes,
    };
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

  onSearchTextChanged(String text) {
    String? pattern = text.toLowerCase().trim();
    if (pattern.isNotEmpty) {
      names = [];

      names?.addAll(_userprovider.Employees!.where((element) =>
          (element.FirstName?.toLowerCase().contains(pattern) ?? false) ||
          (element.LastName?.toLowerCase().contains(pattern) ?? false) ||
          (element.Status?.toLowerCase().contains(pattern) ?? false) ||
          (element.MiddleName?.toLowerCase().contains(pattern) ?? false) ||
          (element.StartDate?.toLowerCase().contains(pattern) ?? false) ||
          (element.Gender?.toLowerCase().contains(pattern) ?? false) ||
          (element.EmployeeType?.toLowerCase().contains(pattern) ?? false)));
    } else {
      names = _userprovider.Employees;
    }
    if (mounted) setState(() {});
  }

  TextEditingController search = TextEditingController();
  List<EmployeeModel>? names;

  List<FilterChipData>? filterchips;
  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    currentTheme = context.watchtheme.currentTheme;
    if (def_emp == null) {
      if (_userprovider.untagged_employeenames.isNotEmpty) {
        def_emp = _userprovider.untagged_employeenames.first ?? '';
      }
      filterchips = _userprovider.workspaces
          .map((branch) =>
              FilterChipData(label: branch.branchname ?? '', isSelected: false))
          .toList();
    }
    return SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context).translate("UserManagement_title"),
            ),
            backgroundColor: Color.fromARGB(255, 74, 63, 221),
            centerTitle: true,
          ),
          backgroundColor: _userprovider.employees_mapping.isEmpty
              ? currentTheme.canvasColor
              : currentTheme.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: _userprovider.isempfetching
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        ...List.generate(3, (int index) => loader())
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ...?_userprovider.employees_mapping?.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border(
                                  left: BorderSide(
                                      color: Colors.indigo, width: 3),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, left: 8, top: 8),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            "${e.value?.first.FirstName}"
                                            ' '
                                            "${e.value?.first.LastName}",
                                            style: currentTheme
                                                .textTheme.displayLarge,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: InkWell(
                                                onTap: () {
                                                  // _showsubcatbottom_transport();

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsermanagementAction(
                                                                  edit: true,
                                                                  defname:
                                                                      "${e.value?.first.FirstName} ${e.value?.first.LastName}",
                                                                  companynames: [
                                                                    for (var branch
                                                                        in _userprovider
                                                                            .workspaces)
                                                                      {
                                                                        "WorkspaceID":
                                                                            branch.workspaceid,
                                                                        "BranchID":
                                                                            branch.branchid,
                                                                        "BranchName":
                                                                            branch.branchname,
                                                                        if (branch.iscrm ==
                                                                            true)
                                                                          "ISCRM":
                                                                              e.value!.where((br) => br.BranchName == branch.branchname).map((br) => br.iscrm ?? false).firstOrNull ?? false,
                                                                        if (branch.isaccounting ==
                                                                            true)
                                                                          "ISAccounting":
                                                                              e.value!.where((br) => br.BranchName == branch.branchname).map((br) => br.isaccounting ?? false).firstOrNull ?? false,
                                                                      }

                                                                    // for (var branch
                                                                    //     in _userprovider
                                                                    //         .workspaces)
                                                                    //   branch.branchname!:
                                                                    //       {
                                                                    //     if (branch
                                                                    //             .iscrm ==
                                                                    //         true)
                                                                    //       "CRM": e.value!
                                                                    //               .where((br) => br.BranchName == branch.branchname)
                                                                    //               .map((br) => br.iscrm ?? false)
                                                                    //               .firstOrNull ??
                                                                    //           false,
                                                                    //     if (branch
                                                                    //             .isaccounting ==
                                                                    //         true)
                                                                    //       "Accounting": e
                                                                    //               .value!
                                                                    //               .where((br) => br.BranchName == branch.branchname)
                                                                    //               .map((br) => br.isaccounting ?? false)
                                                                    //               .firstOrNull ??
                                                                    //           false,
                                                                    //   }
                                                                  ]

                                                                  //  filterchips
                                                                  //     ?.map((filter) => FilterChipData(
                                                                  //         label: filter.label,
                                                                  //         isSelected: e.value!
                                                                  //             .any((branch) =>
                                                                  //                 branch
                                                                  //                     .BranchName ==
                                                                  //                 filter
                                                                  //                     .label))
                                                                  // )
                                                                  // .toList()
                                                                  )));

                                                  // _usermanaging(context, true,
                                                  //     additems: e.value
                                                  //         ?.map((r) => DropdownItem(
                                                  //             label: r.BranchName!,
                                                  //             value: r.BranchID!,
                                                  //             selected: true))
                                                  //         .toList(),
                                                  //     defname: e.value?.first.FirstName);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.black45,
                                                  size: 18,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0, left: 10),
                                            child: InkWell(
                                                onTap: () async {
                                                  bool out =
                                                      await _showMyDialogdelete(
                                                          context,
                                                          currentTheme);

                                                  if (out) {
                                                    var jsonout =
                                                        buildDeleteAllPayload([
                                                      for (var branch
                                                          in _userprovider
                                                              .workspaces)
                                                        {
                                                          "WorkspaceID": branch
                                                              .workspaceid,
                                                          "BranchID":
                                                              branch.branchid,
                                                          "BranchName":
                                                              branch.branchname,
                                                          if (branch.iscrm ==
                                                              true)
                                                            "ISCRM": e.value!
                                                                    .where((br) =>
                                                                        br.BranchName ==
                                                                        branch
                                                                            .branchname)
                                                                    .map((br) =>
                                                                        br.iscrm ??
                                                                        false)
                                                                    .firstOrNull ??
                                                                false,
                                                          if (branch
                                                                  .isaccounting ==
                                                              true)
                                                            "ISAccounting": e
                                                                    .value!
                                                                    .where((br) =>
                                                                        br.BranchName ==
                                                                        branch
                                                                            .branchname)
                                                                    .map((br) =>
                                                                        br.isaccounting ??
                                                                        false)
                                                                    .firstOrNull ??
                                                                false,
                                                        }
                                                    ]);
                                                    var Emp = _userprovider
                                                        .Employee_selectedworkspace!
                                                        .where((emp) =>
                                                            emp.FirstName ==
                                                                e.value?.first
                                                                    .FirstName &&
                                                            emp.LastName ==
                                                                e.value?.first
                                                                    .LastName)
                                                        .toList();

                                                    context.loaderOverlay
                                                        .show();

                                                    bool out = await _userprovider
                                                        .usermangementaction(
                                                            false,
                                                            true,
                                                            Emp.first.UserID,
                                                            jsonout,
                                                            Emp.first.EmailID,
                                                            Emp.first
                                                                .EmployeeType,
                                                            Emp.first
                                                                .PhoneNumber,
                                                            Emp.first.FirstName,
                                                            Emp.first.LastName,
                                                            Emp.first.ID);
                                                    context.loaderOverlay
                                                        .hide();
                                                    if (out) {
                                                      const snackBar = SnackBar(
                                                          duration: Duration(
                                                              seconds: 5),
                                                          content:
                                                              Text("Success"),
                                                          backgroundColor:
                                                              Colors.green);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      const snackBar = SnackBar(
                                                          duration: Duration(
                                                              seconds: 5),
                                                          content:
                                                              Text("Failed"),
                                                          backgroundColor:
                                                              Colors.red);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  }
                                                  // _showsubcatbottom_transport();
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.black45,
                                                  size: 18,
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, left: 8, top: 8),
                                        child: Text(
                                          "${e.value?.first.EmployeeType}",
                                          style: currentTheme
                                              .textTheme.displayMedium
                                              ?.copyWith(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       right: 8, left: 8, top: 8),
                                      //   child: Text(
                                      //     "${e.value?.first.PhoneNumber}",
                                      //     style: currentTheme.textTheme.displayMedium
                                      //         ?.copyWith(
                                      //             color: Colors.black87,
                                      //             fontWeight: FontWeight.w400),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  ...?e.value?.map((br) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 8, right: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(br.BranchName ?? '',
                                                    style: currentTheme
                                                        .textTheme.displayMedium
                                                        ?.copyWith(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                44, 69, 216))),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 8, bottom: 8),
                                              child: Row(children: [
                                                if (br.iscrm ?? false)
                                                  Chip(
                                                    backgroundColor:
                                                        Colors.indigo[50],
                                                    label: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          size: 15,
                                                          color: Colors.indigo,
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "CRM",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                if (br.isaccounting ?? false)
                                                  Chip(
                                                    backgroundColor:
                                                        Colors.indigo[50],
                                                    label: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          size: 15,
                                                          color: Colors.indigo,
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "Accounting",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ]),
                                            )
                                          ],
                                        ),
                                      ))

                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       right: 8, left: 8, top: 8, bottom: 8),
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Text(
                                  //           overflow: TextOverflow.ellipsis,
                                  //           maxLines: 3,
                                  //           "${e.value?.map((r) => (
                                  //                 r.BranchName,
                                  //                 r.iscrm ?? '- CRM',
                                  //                 r.isaccounting ?? '- Accounting'
                                  //               )).join(' , ')}",
                                  //           style: currentTheme.textTheme.displayMedium
                                  //               ?.copyWith(
                                  //                   color: const Color.fromARGB(
                                  //                       255, 44, 69, 216)),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              )),
                        ),
                      ),
                      if (_userprovider.employees_mapping.isEmpty)
                        Nodatafound(),
                      SizedBox(
                        height: 65,
                      ),
                    ],
                  ),
          ),
          floatingActionButton: _userprovider.untagged_employeenames.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      // _usermanaging(context, false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsermanagementAction(
                                      edit: false,
                                      // defname:,

                                      // companynames: {
                                      //   for (var branch
                                      //       in _userprovider.workspaces)

                                      //     branch.branchname!: {
                                      //       if (branch.iscrm == true)
                                      //         "CRM": false,
                                      //       if (branch.isaccounting == true)
                                      //         "Accounting": false
                                      //     }
                                      // }

                                      companynames: [
                                        for (var branch
                                            in _userprovider.workspaces)
                                          {
                                            "WorkspaceID": branch.workspaceid,
                                            "BranchID": branch.branchid,
                                            "BranchName": branch.branchname,
                                            if (branch.iscrm == true)
                                              "ISCRM": false,
                                            if (branch.isaccounting == true)
                                              "ISAccounting": false
                                          }
                                      ]

                                      // _userprovider.workspaces
                                      //     .map((branch) => FilterChipData(
                                      //         label: branch.branchname ?? '',
                                      //         isSelected: false))
                                      //     .toList(),
                                      )));
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("UserManagement_add"),
                          style: currentTheme.textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 16),
                        ),
                      )),
                    ),
                  ),
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
        ));
  }
}
