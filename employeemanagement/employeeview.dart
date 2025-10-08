import 'dart:convert';
import 'dart:io';

import 'package:crm_generatewealthapp/Accounting/models/EmployeeModel.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/employeemanagement/employeeaction.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Employeeview extends StatefulWidget {
  const Employeeview({super.key});

  @override
  State<Employeeview> createState() => _EmployeeviewState();
}

class _EmployeeviewState extends State<Employeeview> {
  late Userprovider _userprovider;
  late ThemeData currentTheme;

  @override
  void initState() {
    // TODO: implement initState
    // names = context.readuser.Employees;

    super.initState();
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

  filechoose() async {
    final result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx', 'csv']);

    if (result != null) {
      final file = result.files.single;
      final filename = file.extension;
      // get bytes
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();

      // encode to base64
      final base64String = base64Encode(bytes);

      if (base64String.isNotEmpty) {
        try {
          context.loaderOverlay.show();
          bool out = await _userprovider.addemployyes(base64String, filename,
              null, null, null, null, null, null, null, null, null, null, null);
          context.loaderOverlay.hide();

          if (out) {
            setState(() {
              names = null;
              search.text = '';
            });
            context.loaderOverlay.hide();
            const snackBar = SnackBar(
                duration: Duration(seconds: 3),
                content: Text("Success"),
                backgroundColor: Colors.green);

            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.pop(context, true);
          } else {
            context.loaderOverlay.hide();
            const snackBar = SnackBar(
                duration: Duration(seconds: 3),
                content: Text("Failed"),
                backgroundColor: Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          }
        } on Exception catch (e) {
          print(e.toString());
          context.loaderOverlay.show();
          // TODO
        }
      }
    } else {
      print("no file chosen");
    }
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

  Future<bool> _showMyDialogdelete(context, currentTheme) async {
    bool? lst = false;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context).translate("Employee_deletetitle"),
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SizedBox(
              height: 75,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate("Employee_deletedesc"),
                    style: TextStyle(height: 1.3),
                  )
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

  _showImagePickerOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (
          BuildContext context,
        ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            {
              return SafeArea(
                child: SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                filechoose();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SizedBox(
                                          width: 40,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.primaryColor,
                                            radius: 20,
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    currentTheme.canvasColor,
                                                radius: 16,
                                                child: Icon(
                                                  Icons.file_upload,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("UploadFile"),
                                        style:
                                            currentTheme.textTheme.displayLarge,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: currentTheme.primaryColor,
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Employeeaction(edit: false),
                                    )).then((value) {
                                  if (value ?? false) {
                                    setState(() {
                                      names = null;
                                      search.text = '';
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SizedBox(
                                          width: 40,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.primaryColor,
                                            radius: 20,
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    currentTheme.canvasColor,
                                                radius: 16,
                                                child: Icon(
                                                  Icons.view_list_sharp,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("ManualEntry"),
                                        style:
                                            currentTheme.textTheme.displayLarge,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: currentTheme.primaryColor,
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          });
        });
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

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    currentTheme = context.watchtheme.currentTheme;
    if (names == null) {
      names = _userprovider.Employees;
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("Employee_title"),
        ),
        backgroundColor: Color.fromARGB(255, 74, 63, 221),
        centerTitle: true,
      ),
      backgroundColor: names!.isEmpty
          ? currentTheme.canvasColor
          : currentTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
          child: _userprovider.empfetch
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 10, right: 10, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.indigo),
                          color: Colors.white,
                        ),

                        // width: MediaQuery.of(context).size.width * 0.40,
                        child: Center(
                          child: TextFormField(
                            onChanged: onSearchTextChanged,
                            controller: search,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                contentPadding: const EdgeInsets.only(
                                    top: 15,
                                    left: 10), // add padding to adjust text
                                isDense: true,
                                hintText:
                                    '${AppLocalizations.of(context).translate("common_search")}',
                                border: InputBorder.none),
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
                    ),
                    ...?names?.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border(
                                left:
                                    BorderSide(color: Colors.indigo, width: 3),
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
                                          "${e.FirstName}"
                                          ' '
                                          "${e.LastName}",
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
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Employeeaction(
                                                        edit: true,
                                                        email: e.EmailID,
                                                        id: e.ID,
                                                        employeeid:
                                                            e.EmployeeID,
                                                        employeetype:
                                                            e.EmployeeType,
                                                        enddate: e.EndDate,
                                                        firstname: e.FirstName,
                                                        gender: e.Gender,
                                                        lasename: e.LastName,
                                                        middlename:
                                                            e.MiddleName,
                                                        phone: e.PhoneNumber,
                                                        startdate: e.StartDate,
                                                        status: e.Status,
                                                      ),
                                                    )).then((value) {
                                                  if (value ?? false) {
                                                    setState(() {
                                                      names = null;
                                                      search.text = '';
                                                    });
                                                  }
                                                });
                                                // _showsubcatbottom_transport();
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
                                                bool dialogout =
                                                    await _showMyDialogdelete(
                                                        context, currentTheme);

                                                if (dialogout) {
                                                  if (e.UserID != null ||
                                                      e.UserID != '') {
                                                    var jsonout;
                                                    var empuser = _userprovider
                                                        .employees_mapping
                                                        .entries
                                                        .where((ue) =>
                                                            ue.value?.first
                                                                    .FirstName ==
                                                                e.FirstName &&
                                                            ue.value?.first
                                                                    .LastName ==
                                                                e.LastName)
                                                        .toSet();

                                                    if (empuser.isNotEmpty) {
                                                      jsonout =
                                                          buildDeleteAllPayload([
                                                        for (var branch
                                                            in _userprovider
                                                                .workspaces)
                                                          {
                                                            "WorkspaceID": branch
                                                                .workspaceid,
                                                            "BranchID":
                                                                branch.branchid,
                                                            "BranchName": branch
                                                                .branchname,
                                                            if (branch.iscrm ==
                                                                true)
                                                              "ISCRM": empuser
                                                                      ?.first
                                                                      .value!
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
                                                              "ISAccounting": empuser
                                                                      ?.first
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

                                                      _userprovider
                                                          .usermangementaction(
                                                              false,
                                                              true,
                                                              e.UserID,
                                                              jsonout,
                                                              e.EmailID,
                                                              e.EmployeeType,
                                                              e.PhoneNumber,
                                                              e.FirstName,
                                                              e.LastName,
                                                              e.ID);
                                                    }

                                                    // var Emp = _userprovider.Employee_selectedworkspace! .where((emp) =>
                                                    //         emp.FirstName ==
                                                    //         e.value?.first
                                                    //             .FirstName && emp.LastName==e.value?.first.LastName)
                                                    //     .toList();

                                                    context.loaderOverlay
                                                        .show();

                                                    bool out =
                                                        await _userprovider
                                                            .deleteemployyes(
                                                                e.ID);

                                                    context.loaderOverlay
                                                        .hide();
                                                    if (out) {
                                                      setState(() {
                                                        names = null;
                                                        search.text = '';
                                                      });
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
                                                }
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
                                        "${e.EmployeeType}",
                                        style: currentTheme
                                            .textTheme.displayMedium
                                            ?.copyWith(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ),
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
                                        "${AppLocalizations.of(context).translate("StartDate")} : ${(e.StartDate != null) ? DateFormat("dd MMM yyyy").format(DateTime.parse(e.StartDate ?? '')) : ''}",
                                        style: currentTheme
                                            .textTheme.displaySmall
                                            ?.copyWith(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: e.Status == "Active"
                                                ? Colors.green[50]
                                                : Colors.red[50]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e.Status ?? '',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: e.Status == "Active"
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            )),
                      ),
                    ),
                    if (names!.isEmpty) Nodatafound(),
                    SizedBox(
                      height: 65,
                    ),
                  ],
                )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () {
            _showImagePickerOptions();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => Employeeaction(
            //         edit: false,
            //       ),
            //     ));
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.indigo),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                AppLocalizations.of(context).translate("Employee_add"),
                style: currentTheme.textTheme.displayMedium
                    ?.copyWith(color: Colors.white, fontSize: 16),
              ),
            )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    ));
  }
}
