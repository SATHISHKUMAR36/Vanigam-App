import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/constant.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'contactmodel.dart';

class EditContact extends StatefulWidget {
  String appbarname;
  String? userid;
  String? name;
  String? email;
  String? phone;
  String? addressline1;
  String? city;
  String? state;
  String? pincode;
  String? country;
  String? tag;
  String? lastmsged;
  String? nextmsgdate;
  String? customertype; // LLp,ltd,huf, for ca
  String? actiontype; // call ,mail , faxfile
  String? stakeholdertype;
  bool edit;

  String? productid; //Gst ,advtax, annual tax, notices
  EditContact(
      {super.key,
      this.userid,
      this.name,
      this.email,
      this.phone,
      this.addressline1,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.lastmsged,
      this.nextmsgdate,
      this.customertype, // LLp,ltd,huf, for ca
      this.actiontype,
      required this.edit, // call ,mail , faxfile

      this.tag, //Gst ,advtax, annual tax, notices for ca
      required this.appbarname,
      this.stakeholdertype});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  ValueNotifier<bool> isfilter = ValueNotifier(false);
  List<Contacts>? data;
  bool light = false;
  List<Contacts>? names;

  Widget _buildInputField(
    String label,
    // Function(String?) onSaved,
    TextEditingController controller,
    bool link,
    IconData icon,
    currentTheme, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: currentTheme.textTheme.displayMedium
              .copyWith(color: currentTheme.primaryColor),
          prefixIcon: Icon(icon, color: currentTheme.primaryColor),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (link && !value.contains('http')) {
            return 'Please enter link only';
          }
          return null;
        },
        // onSaved: onSaved,
      ),
    );
  }

  late Userprovider _userProvider;
    late Crmprovider _crmProvider;

  sortdata() async {
    isfilter.value = true;
    data = _crmProvider.contacts;
    names = data?.where((element) {
      return element.userid == widget.userid;
    }).toList();

    name.text = widget.name ?? '';
    addressline1.text = widget.addressline1 ?? '';
    city.text = widget.city ?? '';
    state.text = widget.state ?? '';
    country.text = widget.country ?? '';
    pincode.text = widget.pincode ?? '';
    email.text = widget.email ?? '';
    phone.text = widget.phone ?? '';
    customertype = widget.customertype;

    nextmsgdate = DateTime.tryParse(
        widget.nextmsgdate ?? DateFormat("yyyy-MM-dd").format(DateTime.now()));
    lastmsgdate = DateTime.tryParse(
        widget.lastmsged ?? DateFormat("yyyy-MM-dd").format(DateTime.now()));
    actiontype = widget.actiontype ?? actionlist.first;
    isfilter.value = false;
  }

  List<String> actionlist = ["Call", "Fax File", "Mail"];
  Widget dropdown(String dropdownvalue, List<String> list, bool actions) {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: list.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          if (!actions) {
            customertype = newValue;
          } else {
            actiontype = newValue;
          }
        });
      },
    );
  }

  String? customertype;
  String? actiontype;

  DateTime? selectedDate;
  DateTime? nextmsgdate;
  DateTime? lastmsgdate;

  Future<void> selectDate(
      BuildContext context, currentTheme, isnextdate) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: !isnextdate ? DateTime(2023) : DateTime.now(),
      lastDate: isnextdate ? DateTime(2080) : DateTime.now(),
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
      if (isnextdate) {
        nextmsgdate = selectedDate ?? DateTime.now();
      } else {
        lastmsgdate = selectedDate ?? DateTime.now();
      }
    });
  }

  List<CAProducts> filters = [];

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addressline1 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController tag = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
        _crmProvider = context.watchcrm;

    if (data == null) {
      sortdata();
    }
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.appbarname),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        backgroundColor: currentTheme.primaryColor,
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: isfilter,
          builder: (BuildContext context, value, Widget? child) {
            return value
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 30),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("common_name")}',
                                  name,
                                  false,
                                  Icons.person,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("common_email")}',
                                  email,
                                  false,
                                  Icons.mail,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("form_phone")}',
                                  phone,
                                  false,
                                  Icons.phone,
                                  currentTheme,
                                  keyboardType: TextInputType.number)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("AddressLine1")}',
                                  addressline1,
                                  false,
                                  Icons.home,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("City")}',
                                  city,
                                  false,
                                  Icons.location_city,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("State")}',
                                  state,
                                  false,
                                  Icons.my_location,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("Country")}',
                                  country,
                                  false,
                                  Icons.location_on,
                                  currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("Pincode")}',
                                  pincode,
                                  false,
                                  Icons.numbers,
                                  currentTheme,
                                  keyboardType: TextInputType.number)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField(
                                  '${AppLocalizations.of(context).translate("Tag")}',
                                  tag,
                                  false,
                                  Icons.tag_faces,
                                  currentTheme)),
                          if (widget.edit) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: InkWell(
                                onTap: () {
                                  selectDate(context, currentTheme, false);
                                },
                                child: Container(
                                  // height: 60,
                                  // width:MediaQuery.of(context).size.width/,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8, left: 10),
                                              child: Icon(
                                                Icons.calendar_month,
                                                color:
                                                    currentTheme.primaryColor,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Text(
                                                "${AppLocalizations.of(context).translate("lasrMsgDate")} :",
                                                style: currentTheme
                                                    .textTheme.displayMedium!
                                                    .copyWith(
                                                        color: currentTheme
                                                            .primaryColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Center(
                                            child: Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(lastmsgdate ??
                                                      DateTime.now())
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 83, 180),
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: InkWell(
                                onTap: () {
                                  selectDate(context, currentTheme, true);
                                },
                                child: Container(
                                  height: 60,
                                  // width:MediaQuery.of(context).size.width/,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10),
                                            child: Icon(
                                              Icons.calendar_month,
                                              color: currentTheme.primaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              "${AppLocalizations.of(context).translate("Nextmsgdate")} :",
                                              style: currentTheme
                                                  .textTheme.displayMedium!
                                                  .copyWith(
                                                      color: currentTheme
                                                          .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Center(
                                          child: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(nextmsgdate ??
                                                    DateTime.now())
                                                .toString(),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 83, 180),
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Container(
                                height: 60,
                                // width:MediaQuery.of(context).size.width/,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, left: 10),
                                          child: Icon(
                                            Icons.call_to_action,
                                            color: currentTheme.primaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            "${AppLocalizations.of(context).translate("ActionType")} :",
                                            style: currentTheme
                                                .textTheme.displayMedium!
                                                .copyWith(
                                                    color: currentTheme
                                                        .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: dropdown(
                                            actiontype ?? actionlist.first,
                                            actionlist,
                                            true)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Container(
                                // height: 60,
                                // width:MediaQuery.of(context).size.width/,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10),
                                            child: Icon(
                                              Icons.do_not_disturb,
                                              color: currentTheme.primaryColor,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Text(
                                                "${AppLocalizations.of(context).translate("DND")} :",
                                                style: currentTheme
                                                    .textTheme.displayMedium!
                                                    .copyWith(
                                                        color: currentTheme
                                                            .primaryColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Switch(
                                          // This bool value toggles the switch.
                                          value: light,
                                          activeColor:
                                              currentTheme.primaryColor,
                                          onChanged: (bool value) {
                                            // This is called when the user toggles the switch.
                                            setState(() {
                                              light = value;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ] // if (_crmProvider
                          //         .userdata!.stakeholdertypes!.length ==
                          //     1)
                          //   Padding(
                          //     padding: const EdgeInsets.only(
                          //         bottom: 10, left: 10, right: 10),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(12),
                          //         color: Colors.white,
                          //       ),
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     right: 8, left: 10, top: 15),
                          //                 child: Icon(
                          //                   Icons.data_thresholding,
                          //                   color: currentTheme.primaryColor,
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     right: 8, top: 15),
                          //                 child: Text(
                          //                   "Product :",
                          //                   style: currentTheme
                          //                       .textTheme.displayMedium!
                          //                       .copyWith(
                          //                           color: currentTheme
                          //                               .primaryColor),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Wrap(
                          //             spacing: 5.0,
                          //             children: CAProducts.values
                          //                 .map((CAProducts exercise) {
                          //               if (filters.isEmpty) {
                          //                 if (widget.productnames
                          //                         ?.contains(exercise.name) ??
                          //                     false) filters.add(exercise);
                          //               }
                          //               return FilterChip(
                          //                 selectedColor: currentTheme
                          //                     .primaryColor
                          //                     .withAlpha(75),
                          //                 label: Text(exercise.name),
                          //                 selected: filters.contains(exercise),
                          //                 onSelected: (bool selected) {
                          //                   setState(() {
                          //                     if (selected) {
                          //                       filters.add(exercise);
                          //                     } else {
                          //                       filters.remove(exercise);
                          //                     }
                          //                   });
                          //                 },
                          //               );
                          //             }).toList(),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          ,
                          SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () async {
                              context.loaderOverlay.show();
                              if (!widget.edit) {
                                if (name.text.isNotEmpty) {
                                  await _crmProvider.addcontact(
                                    _userProvider.selectedworkspace?.branchid,
                                      name.text,
                                      email.text,
                                      phone.text,
                                      addressline1.text,
                                      city.text,
                                      state.text,
                                      pincode.text,
                                      country.text,
                                      tag.text);

                                  _crmProvider.getstackholdertypes(_userProvider.selectedworkspace?.branchid,);
                                  context.loaderOverlay.hide();

                                  Navigator.pop(context);
                                } else {
                                  context.loaderOverlay.hide();
                                  final snackBar = SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                          "${AppLocalizations.of(context).translate("pls_name_email")}"),
                                      backgroundColor: Colors.red);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } else {
                                // clientid,tenantid,dnd,name,email,actiontype,nextmsgdate,phone,addressline1,city,state,pincode,country,tag,stakeholdertype,agentid, role, productid

                                await _crmProvider.editsingle(
                                  widget.userid,
                                  _userProvider.selectedworkspace?.branchid,
                                  light ? 1 : 0,
                                  name.text.trim(),
                                  email.text.trim(),
                                  actiontype,
                                  DateFormat("yyyy-MM-dd")
                                      .format(nextmsgdate ?? DateTime.now()),
                                  DateFormat("yyyy-MM-dd")
                                      .format(lastmsgdate ?? DateTime.now()),
                                  phone.text,
                                  addressline1.text,
                                  city.text,
                                  state.text,
                                  pincode.text,
                                  country.text,
                                  tag.text,
                                  widget.stakeholdertype,
                                );
                                context.loaderOverlay.hide();
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, bottom: 30, top: 15),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: currentTheme.primaryColor),
                                child: Center(
                                    child: Text(
                                  widget.appbarname,
                                  style: const TextStyle(
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
                  );
          }),
    ));
  }
}
