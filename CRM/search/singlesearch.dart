import 'package:crm_generatewealthapp/CRM/choose_template.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/common/shimmer.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/CRM/search/searchmodel.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class Singlesearch extends StatefulWidget {
  String? userid;
  bool? access;
  String? productid;
  String? role;
  String? agentid;

  Singlesearch(
      {super.key,
      this.userid,
      this.access,
      this.productid,
      this.role,
      this.agentid});
  @override
  State<Singlesearch> createState() => _SinglesearchState();
}

class _SinglesearchState extends State<Singlesearch> {
  List<Searchmodel>? names;
  List<Searchmodel>? data;

  late Userprovider _userProvider;
    late Crmprovider _crmProvider;


  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        // leading: ShimmerWidget.circular(radius: 60),
        title: ShimmerWidget.rectangular(
          width: MediaQuery.of(context).size.width / 2.1,
          height: 80,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  calldata() {
    data = _crmProvider.searchdata;
    names = data?.where((element) {
      return element.userid == widget.userid;
    }).toList();
    if (names!.isNotEmpty) {
      if (names?.first.nextmsgdate != null && currentdate == null) {
        currentdate = DateTime.tryParse(names?.first.nextmsgdate ?? '');
      }
    }
  }

  addnotes(clientid, date, content, stackholdertype) async {
    await _crmProvider.insertnotes(
      clientid,
      _userProvider.selectedworkspace?.branchid,
      date,
      content,
      stackholdertype,
    );

    await _crmProvider.getallsearchdata(_userProvider.selectedworkspace?.branchid,);
  }

  updatenotes(clientid, date, content, stackholdertype, noteid) async {
    await _crmProvider.updatenotes(
      clientid,
      _userProvider.selectedworkspace?.branchid,
      date,
      content,
      stackholdertype,
      noteid,
    );

    await _crmProvider.getallsearchdata(_userProvider.selectedworkspace?.branchid,);
  }

  deletenote(stackholdertype, noteid) async {
    await _crmProvider.deletenote(
      stackholdertype,
      noteid,
      _userProvider.selectedworkspace?.branchid,
    );

    await _crmProvider.getallsearchdata(_userProvider.selectedworkspace?.branchid,);
  }

  Future<List> _showMyDialog(
      context, currentTheme, notes, producttype, lastmsgdates) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController note = TextEditingController();
    note.text = notes;
    DateTime? selectedDate;

    DateTime? lastmsgdate = lastmsgdates.isNotEmpty
        ? DateTime.tryParse(lastmsgdates)
        : DateTime.now();

    List? lst;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "${AppLocalizations.of(context).translate("AddNote")}",
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () async {
                          selectedDate = await showDatePicker(
                            context: context,
                            initialDate: lastmsgdate ?? DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: currentTheme
                                        .primaryColor, // header background color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          setState(() {
                            lastmsgdate = selectedDate ?? DateTime.now();
                          });
                        },
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
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context).translate("lasrMsgDate")} :",
                                      style: currentTheme
                                          .textTheme.displayMedium!
                                          .copyWith(
                                              color: currentTheme.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(lastmsgdate ?? DateTime.now())
                                      .toString(),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 8, 83, 180),
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: note,
                        decoration: InputDecoration(
                            labelText:
                                '${AppLocalizations.of(context).translate("Note")}',
                            labelStyle: currentTheme.textTheme.displaySmall,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          var availableValue = value ?? '';
                          if (availableValue.isEmpty) {
                            return 'Note is requiered..!';
                          } else if (availableValue == notes ||
                              lastmsgdate == selectedDate) {
                            return 'Please do changes..!';
                          }
                          return null;
                        },
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
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(lst = [
                          true,
                          note.text,
                          DateFormat("yyyy-MM-dd")
                              .format(lastmsgdate ?? DateTime.now())
                        ]);
                      }
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

  DateTime? selectedDate;
  DateTime? currentdate;

  Future<void> selectDate(BuildContext context, currentTheme) async {
    selectedDate = await showDatePicker(
      confirmText: 'SAVE',
      context: context,
      initialDate: currentdate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: currentTheme.primaryColor, // header background color
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      currentdate = selectedDate;
      context.loaderOverlay.show();

      _crmProvider.editsingle(
          widget.userid,
          _userProvider.selectedworkspace?.branchid,
          0,
          names?.first.name,
          names?.first.email,
          names?.first.actiontype,
          DateFormat("yyyy-MM-dd").format(currentdate ?? DateTime.now()),
          names?.first.lastmsged,
          names?.first.phone,
          names?.first.address,
          // addressline1,
          // city,
          // state,
          // pincode,
          // country,
          names?.first.address,
          names?.first.address,
          names?.first.address,
          names?.first.address,
          names?.first.tag,
          "Search");

      calldata();

      context.loaderOverlay.hide();
    });
  }

  Future<List> _showMyDialogdelete(context, currentTheme) async {
    List? lst;
    lst = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "${AppLocalizations.of(context).translate("DeleteNote")}",
              style: currentTheme.textTheme.displayLarge,
            ),
            content: SizedBox(
              height: 50,
              child: Column(
                children: [
                  Text(
                      "${AppLocalizations.of(context).translate("Delete_confirmation")}")
                ],
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
                      Navigator.of(context).pop(lst = [false]);
                    },
                  ),
                  TextButton(
                    child: Text(
                      '${AppLocalizations.of(context).translate("Yes")}',
                      style: currentTheme.textTheme.bodySmall
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(lst = [true]);
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
        _crmProvider = context.watchcrm;

    if (names == null) {
      calldata();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
              "${AppLocalizations.of(context).translate("SearchView")}"),
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
                height: 10,
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: currentTheme.canvasColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.black12,
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${names?.first.name}",
                                    style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)
                                        .copyWith(
                                            color: currentTheme.primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    names?.first.email ?? '',
                                    style: currentTheme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    names?.first.phone ?? '',
                                    style: currentTheme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: currentTheme.canvasColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${AppLocalizations.of(context).translate("common_address")} ",
                                  style: currentTheme.textTheme.bodySmall,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                names?.first.address ?? "",
                                style: currentTheme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: currentTheme.canvasColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  names?.first.nextmsgdate != null
                                       ? "${AppLocalizations.of(context).translate("NextRemainderdate")}"
                                      : "${AppLocalizations.of(context).translate("LasrRemainderdate")}",
                                  style: currentTheme.textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                currentdate != null
                                    ? Row(
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(currentdate!),
                                            style: currentTheme
                                                .textTheme.bodyLarge
                                                ?.copyWith(color: Colors.blue),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                selectDate(
                                                    context, currentTheme);
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blueGrey,
                                                size: 20,
                                              ))
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          selectDate(context, currentTheme);
                                        },
                                        child: CircleAvatar(
                                            radius: 15,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            )))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      (_crmProvider.getcontactdata ||
                              _crmProvider.getcontactnote)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loader(),
                                loader(),
                                loader(),
                                loader(),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${AppLocalizations.of(context).translate("Note")} ",
                                                style: currentTheme
                                                    .textTheme.bodySmall,
                                              )),
                                          InkWell(
                                            onTap: () async {
                                              var insernote =
                                                  await _showMyDialog(
                                                      context,
                                                      currentTheme,
                                                      '',
                                                      names!.first.productnames
                                                              ?.first ??
                                                          '',
                                                      '');

                                              if (insernote[0]) {
                                                context.loaderOverlay.show();
                                                await addnotes(
                                                    names!.first.userid,
                                                    insernote[2],
                                                    insernote[1],
                                                    names!
                                                        .first.stackholdertype);
                                                calldata();
                                                context.loaderOverlay.hide();
                                                // setState(() {
                                                //   calldata();
                                                // });
                                              }
                                            },
                                            child: CircleAvatar(
                                                radius: 15,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        for (var i = 0;
                                            i < names!.first.notes!.length;
                                            i++) ...[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      currentTheme.canvasColor,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(names!.first
                                                            .notes![i]!['date']
                                                            .toString()),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child: Text(
                                                            names!
                                                                .first
                                                                .notes![i]![
                                                                    'content']
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  var insernote = await _showMyDialog(
                                                                      context,
                                                                      currentTheme,
                                                                      names!
                                                                          .first
                                                                          .notes![
                                                                              i]![
                                                                              'content']
                                                                          .toString(),
                                                                      names!.first
                                                                              .productnames![
                                                                          i],
                                                                      names!
                                                                          .first
                                                                          .notes![
                                                                              i]![
                                                                              'date']
                                                                          .toString());

                                                                  if (insernote[
                                                                      0]) {
                                                                    context
                                                                        .loaderOverlay
                                                                        .show();
                                                                    await updatenotes(
                                                                        names!
                                                                            .first
                                                                            .userid,
                                                                        insernote[
                                                                            2],
                                                                        insernote[
                                                                            1],
                                                                        names!
                                                                            .first
                                                                            .stackholdertype,
                                                                        names!
                                                                            .first
                                                                            .notes![i]!['noteid']);
                                                                    calldata();
                                                                    context
                                                                        .loaderOverlay
                                                                        .hide();
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  var insernote =
                                                                      await _showMyDialogdelete(
                                                                    context,
                                                                    currentTheme,
                                                                  );

                                                                  if (insernote[
                                                                      0]) {
                                                                    context
                                                                        .loaderOverlay
                                                                        .show();
                                                                    await deletenote(
                                                                        names!
                                                                            .first
                                                                            .stackholdertype,
                                                                        names!
                                                                            .first
                                                                            .notes![i]!['noteid']);
                                                                    calldata();
                                                                    context
                                                                        .loaderOverlay
                                                                        .hide();
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              
                InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseTemplate(
                            emails: [names?.first.email],
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, bottom: 10, top: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: currentTheme.primaryColor),
                      child:  Center(
                          child: Text(
                        "${AppLocalizations.of(context).translate("SendMail")}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
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
