import 'dart:io';

import 'package:crm_generatewealthapp/CRM/choose_template.dart';
import 'package:crm_generatewealthapp/CRM/contact/contactmodel.dart';
import 'package:crm_generatewealthapp/CRM/contact/edit_contact.dart';
import 'package:crm_generatewealthapp/CRM/contact/notify.dart';
import 'package:crm_generatewealthapp/CRM/contact/singlecontact.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/nodatafoundwidget.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Contactspage extends StatefulWidget {
  bool? access;
  String? productid;
  String? role;
  String? agentid;
  Contactspage(
      {super.key, this.access, this.productid, this.role, this.agentid});

  @override
  State<Contactspage> createState() => _ContactspageState();
}

class _ContactspageState extends State<Contactspage> {
  List<Contacts>? names;
  List<Map<String, dynamic>> dataList = [];
  List<Contacts>? data;
  List<String?> listtabs = [];
  List<String?> custtabs = [];

  int count = 0;

  onSearchTextChanged(String text) {
    String? pattern = text.toLowerCase().trim();
    if (pattern.isNotEmpty) {
      names = [];

      names?.addAll(data!.where((element) =>
          (element.name?.toLowerCase().contains(pattern) ?? false) ||
          (element.email?.toLowerCase().contains(pattern) ?? false) ||
          (element.address?.toLowerCase().contains(pattern) ?? false)));
    } else {
      names = data;
    }

    if (mounted) setState(() {});
  }

  String select = "Select all";
  TextEditingController search = TextEditingController();

  late Userprovider _userProvider;
    late Crmprovider _crmProvider;

  sortdata() {
    data = _crmProvider.contacts;
    names = data;
    listtabs = _crmProvider.leadstabs?.map((e) => e.name).toList() ?? [];
    custtabs = _crmProvider.customertabs?.map((e) => e.name).toList() ?? [];
    if (data != null) {
      for (int i = 0; i < data!.length; i++) {
        dataList.add({"clientid": data?[i].userid, "isChecked": false});
      }
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Initialize notifications
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          openFile(response.payload!);
        }
      },
    );
  }

// Show notification after saving file (with click action)
  Future<void> showNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel', // Channel ID
      'Download Notifications', // Channel Name
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Download Complete',
      'Tap to open the sample file',
      platformChannelSpecifics,
      payload: filePath, // Store the file path in payload
    );
  }

// Function to open the file
  Future<void> openFile(String filePath) async {
    try {
      await OpenFilex.open(filePath);
    } catch (e) {
      print("⚠️ Error opening file: $e");
    }
  }

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

// Save file to Downloads and show notification
  Future<void> saveFileToDownloads(String assetPath, String fileName) async {
    try {
      Directory? downloadsDir;
      if (await Permission.storage.request().isDenied) {
        print("❌ Storage permission denied.");
        return;
      }

      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      final File file = File(assetPath);
      if (file.existsSync()) {
        await file.delete();
        print("🗑️ Old file deleted: $assetPath");
      }

      if (downloadsDir != null &&
          downloadsDir.existsSync() &&
          await Permission.storage.request().isGranted) {
        final String filePath = '${downloadsDir.path}/$fileName';
        final File file = File(filePath);

        final ByteData data = await rootBundle.load(assetPath);
        await file.writeAsBytes(data.buffer.asUint8List());

        print("✅ File saved successfully: $filePath");

        // Show notification
        await NotificationHelper.showNotification(filePath);
      } else {
        await Permission.storage.request();
        print("❌ Downloads directory not found or not accessible.");
      }
    } catch (e) {
      print("⚠️ Error saving file: $e");
    }
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

  Future<List> _showMyDialog1(context, currentTheme) async {
    List? lst;
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "${AppLocalizations.of(context).translate("Add_Contact")}",
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SizedBox(
              // height: 250,
              // height: 100,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditContact(
                                    edit: false,
                                    appbarname:
                                        "${AppLocalizations.of(context).translate("Add_Contact")}"),
                              ));
                        },
                        child: Container(
                            width: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: currentTheme.primaryColor),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                "${AppLocalizations.of(context).translate("Add_sing_contact")}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ))),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: InkWell(
//                       onTap: () async {
//                         FilePickerResult? result =
//                             await FilePicker.platform.pickFiles(
//                           type: FileType.custom,
//                           allowedExtensions: ['csv', 'xlsx'],
//                         );

//                         if (result != null) {
//                           File file = File(result.files.single.path!);
//                           PlatformFile files = result.files.first;
//                           Uint8List image = await file.readAsBytes();

//                           int sizeInBytes = file.lengthSync();
//                           double sizeInMb = sizeInBytes / (1024 * 1024);
//                           if (sizeInMb > 6) {
//                             Navigator.pop(context);

//                             const snackBar = SnackBar(
//                                 duration: Duration(seconds: 3),
//                                 content: Text("Maximum file size is 5mb..!"),
//                                 backgroundColor: Colors.red);
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           }

//                           // htmldata =  file.readAsStringSync();
//                           // print(htmldata);

//                           else {
//                             context.loaderOverlay.show();
//                            await _crmProvider.addcontactcsv(widget.agentid,widget.role,widget.productid,
//                                 base64Encode(image), files.name.split('.')[1]);

//                                  _crmProvider.getstackholdertypes(
//                                         widget.productid,
//                                         _crmProvider.userdata?.role,
//                                          _crmProvider.userdata?.agentid);
//  if (_crmProvider.userdata?.role ==
//                                       'Agent') {
//                                     _crmProvider.getagent(widget.productid);
//                                   } else if (_crmProvider.userdata?.role ==
//                                       'SuperUser'){
//                                     _crmProvider.getsuperuser(widget.productid);
//                                   }

//                             context.loaderOverlay.hide();

//                             Navigator.pop(context);
//                           }

//                           // setState(() {
//                           //   filename = files.name;
//                           // });
//                         }
//                       },
//                       child: Container(
//                           width: 210,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: currentTheme.primaryColor),
//                           child: const Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Center(
//                                 child: Text(
//                               "Upload Multiple Contacts",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ))),
//                 ),
//                 const Divider(
//                   thickness: 2,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: InkWell(
//                       onTap: () async {
//                         await saveFileToDownloads(
//                             'assets/images/CRM_INSERT_TEMPLATE.xlsx', 'CRM_INSERT_TEMPLATE.xlsx');
//                       },
//                       child: Container(
//                           width: 210,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: currentTheme.primaryColor),
//                           child: const Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Center(
//                                 child: Text(
//                               "Download Sample File",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ))),
//                 ),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Note",
//                       style: currentTheme.textTheme.displayMedium,
//                     )),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                     "If you want to upload multiple contacts, Please provide a data as same as from sample data..! ",
//                     style: currentTheme.textTheme.bodySmall)
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 TextButton(
//                   child: Text(
//                     'Cancel',
//                     style: currentTheme.textTheme.bodySmall
//                         .copyWith(color: Colors.purpleAccent),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(lst = [false]);
//                   },
//                 ),
//                 TextButton(
//                   child: Text(
//                     'Ok',
//                     style: currentTheme.textTheme.bodySmall
//                         .copyWith(color: Colors.purpleAccent),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(lst = [
//                       true,
//                     ]);
                  // },
                  // ),
                ],
              ),
              // ],
            ));
      },
    );
    return lst ?? [];
  }

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
        title: Text("${AppLocalizations.of(context).translate("Contacts")}"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        backgroundColor: currentTheme.primaryColor,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: IconButton(onPressed: () {}, icon: Icon(Icons.upload)),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: _crmProvider.getcontactdata
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width / 2.8,
                          height: 50,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width / 3.8,
                            height: 50,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width / 3.8,
                            height: 50,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      ],
                    ),
                  ),
                  ...List.generate((3), (int index) => loader()),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 50,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 50,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  if (count != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${count} ${AppLocalizations.of(context).translate("Selected")}',
                            style: currentTheme.textTheme.displayLarge,
                          )),
                    ),
                  const SizedBox(
                    height: 2,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Center(
                              child: TextFormField(
                                onChanged: onSearchTextChanged,
                                controller: search,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 20,
                                        left: 10), // add padding to adjust text
                                    isDense: true,
                                    hintText:
                                        '${AppLocalizations.of(context).translate("common_search")}',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                                    dataList.add({
                                      "email": data?[i].email,
                                      "isChecked": true
                                    });
                                  }
                                  var selected = dataList.where((val) {
                                    return val["isChecked"] == true;
                                  }).toList();
                                  count = selected.length;
                                });
                              } else {
                                setState(() {
                                  select = "Select all";
                                  for (int i = 0; i < data!.length; i++) {
                                    dataList.add({
                                      "email": data?[i].email,
                                      "isChecked": false
                                    });
                                  }
                                  var selected = dataList.where((val) {
                                    return val["isChecked"] == true;
                                  }).toList();
                                  count = selected.length;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      currentTheme.primaryColor.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    '${AppLocalizations.of(context).translate("${select}")}',
                                    style: currentTheme.textTheme.displayLarge
                                        ?.copyWith(
                                            color: currentTheme.primaryColor)),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showMyDialog1(context, currentTheme);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      currentTheme.primaryColor.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${AppLocalizations.of(context).translate("Add_Contact")}',
                                    style: currentTheme.textTheme.displayLarge
                                        ?.copyWith(
                                            color: currentTheme.primaryColor)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        if (names!.isEmpty) ...[
                          Nodatafound(),
                          SizedBox(
                            height: 65,
                          ),
                        ],
                        ...?names?.map(
                          (e) => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 12, left: 12, bottom: 8),
                              child: InkWell(
                                onTap: () {
                                  // _showsubcatbottom(currentTheme, e.userid);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Singlecontact(
                                          userid: e.userid,
                                          access: widget.access,
                                          agentid: widget.agentid,
                                          productid: widget.productid,
                                          role: widget.role,
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Checkbox(
                                                  activeColor:
                                                      currentTheme.primaryColor,
                                                  value: dataList[names!
                                                      .indexOf(e)]["isChecked"],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      //                                                   var lst=dataList.where((val){return val["isChecked"]=false;}).toList();
                                                      //                                                   if (lst.isNotEmpty) {
                                                      //   select="Select all";
                                                      // }else{
                                                      //   select="Deselect all";
                                                      // }
                                                      select = "Select all";
                                                      dataList[names!
                                                                  .indexOf(e)]
                                                              ["isChecked"] =
                                                          !dataList[names!
                                                                  .indexOf(e)]
                                                              ["isChecked"];

                                                      var selected =
                                                          dataList.where((val) {
                                                        return val[
                                                                "isChecked"] ==
                                                            true;
                                                      }).toList();
                                                      count = selected.length;
                                                    });
                                                  }),
                                              if (e.name != null) ...[
                                                Text(
                                                  e.name!.length < 34
                                                      ? e.name!
                                                      : e.name!.split(' ')[0],
                                                  // softWrap: true,,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style: currentTheme
                                                      .textTheme.displayLarge
                                                      ?.copyWith(
                                                          color: currentTheme
                                                              .primaryColor),
                                                )
                                              ],
                                            ]),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditContact(
                                                              edit: true,
                                                              appbarname:
                                                                  "${AppLocalizations.of(context).translate("Edit_Contact")}",
                                                              userid: e.userid!,
                                                              actiontype:
                                                                  e.actiontype,
                                                              addressline1:
                                                                  e.address,
                                                              customertype: e
                                                                  .customertype,
                                                              email: e.email,
                                                              lastmsged:
                                                                  e.lastmsged,
                                                              name: e.name,
                                                              nextmsgdate:
                                                                  e.nextmsgdate,
                                                              phone: e.phone,
                                                              stakeholdertype:
                                                                  "Contacts",
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
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          spacing: 8,
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
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            // height: 40,
                            // width: MediaQuery.of(context).size.width / 2.15,
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
                                        listtabs,
                                        listtabs.first,
                                        'Leads');

                                    if (selecttab[0]) {
                                      context.loaderOverlay.show();
                                      await _crmProvider.updatestack(
                                          'Leads',_userProvider.selectedworkspace?.branchid, maillist, selecttab[1]);

                                      await _crmProvider.getstackholdertypes(_userProvider.selectedworkspace?.branchid);

                                      context.loaderOverlay.hide();
                                      _crmProvider.contactsdata(_userProvider.selectedworkspace?.branchid);
                                      _crmProvider.leadsdata(_userProvider.selectedworkspace?.branchid);
                                      _crmProvider.getleadstabs(_userProvider.selectedworkspace?.branchid);
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
                        Expanded(
                          child: Container(
                            // height: 40,
                            // width: MediaQuery.of(context).size.width / 2.15,
                            decoration: BoxDecoration(
                                color: currentTheme.primaryColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 12, top: 12),
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    "${AppLocalizations.of(context).translate("MoveToCustomers")}",
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
                                        custtabs,
                                        custtabs.first,
                                        'Customers');

                                    if (selecttab[0]) {
                                      context.loaderOverlay.show();
                                      await _crmProvider.updatestack(
                                          'Customers',_userProvider.selectedworkspace?.branchid, maillist, selecttab[1]);
                                      await _crmProvider.getstackholdertypes(_userProvider.selectedworkspace?.branchid);

                                      _crmProvider.contactsdata(_userProvider.selectedworkspace?.branchid);
                                      _crmProvider.customersdata(_userProvider.selectedworkspace?.branchid);
                                      _crmProvider.getcustomertabs(_userProvider.selectedworkspace?.branchid);
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
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 10),
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
                                      emails:
                                          lst.map((w) => w['email']).toList(),
                                    ),
                                  ));
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
    ));
  }
}
