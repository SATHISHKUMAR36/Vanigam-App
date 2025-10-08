import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/constant.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/CRM/leads/leadsmodel.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditLead extends StatefulWidget {
  String? userid;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? lastmsged;
  String? nextmsgdate;
  String? customertype; // LLp,ltd,huf, for ca
  String? actiontype; // call ,mail , faxfile
  List? productnames; //Gst ,advtax, annual tax, notice  s
  EditLead(
      {super.key,
      this.userid,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.lastmsged,
      this.nextmsgdate,
      this.customertype, // LLp,ltd,huf, for ca
      this.actiontype, // call ,mail , faxfile
      this.productnames //Gst ,advtax, annual tax, notices for ca
      });

  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  ValueNotifier<bool> isfilter = ValueNotifier(false);
  List<Leads>? data;

  List<Leads>? names;

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
    data = _crmProvider.leads;
    names = data?.where((element) {
      return element.userid == widget.userid;
    }).toList();

    name.text = widget.name ?? '';
    address.text = widget.address ?? '';
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
  TextEditingController address = TextEditingController();
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
        title:  Text("Edit Leads${AppLocalizations.of(context).translate("Join_event_mail")}"),
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
                              child: _buildInputField('Name${AppLocalizations.of(context).translate("Join_event_mail")}', name, false,
                                  Icons.person, currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField('Email${AppLocalizations.of(context).translate("Join_event_mail")}', email, false,
                                  Icons.mail, currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField('Phone${AppLocalizations.of(context).translate("Join_event_mail")}', phone, false,
                                  Icons.phone, currentTheme)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: _buildInputField('Address${AppLocalizations.of(context).translate("Join_event_mail")}', address, false,
                                  Icons.home, currentTheme)),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: InkWell(
                              onTap: () {
                                selectDate(context, currentTheme, false);
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
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              "Last Messaged Date${AppLocalizations.of(context).translate("Join_event_mail")} :",
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Center(
                                        child: Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(
                                                  lastmsgdate ?? DateTime.now())
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
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              "Next Message Date${AppLocalizations.of(context).translate("Join_event_mail")} :",
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Center(
                                        child: Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(
                                                  nextmsgdate ?? DateTime.now())
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
                          if (_userProvider.userdata!.tenantname == 'CA')
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
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 10),
                                            child: Icon(
                                              Icons.list,
                                              color: currentTheme.primaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              "Customer Type${AppLocalizations.of(context).translate("Join_event_mail")} :",
                                              style: currentTheme
                                                  .textTheme.displayMedium!
                                                  .copyWith(
                                                      color: currentTheme
                                                          .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //TOOOOOOOOOOOOOOOOOOOOO   DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: dropdown(
                                            customertype!, catypelist, false)),
                                  ],
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
                                          "Action Type${AppLocalizations.of(context).translate("Join_event_mail")} :",
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
                                      padding: const EdgeInsets.only(right: 20),
                                      child: dropdown(
                                          actiontype ?? actionlist.first,
                                          actionlist,
                                          true)),
                                ],
                              ),
                            ),
                          ),
                          if (_userProvider
                                  .userdata!.stakeholdertypes!.length ==
                              1)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, left: 10, top: 15),
                                          child: Icon(
                                            Icons.data_thresholding,
                                            color: currentTheme.primaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, top: 15),
                                          child: Text(
                                            "Product${AppLocalizations.of(context).translate("Join_event_mail")} :",
                                            style: currentTheme
                                                .textTheme.displayMedium!
                                                .copyWith(
                                                    color: currentTheme
                                                        .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      spacing: 5.0,
                                      children: CAProducts.values
                                          .map((CAProducts exercise) {
                                        if (filters.isEmpty) {
                                          if (widget.productnames
                                                  ?.contains(exercise.name) ??
                                              false) filters.add(exercise);
                                        }
                                        return FilterChip(
                                          selectedColor: currentTheme
                                              .primaryColor
                                              .withAlpha(75),
                                          label: Text(exercise.name),
                                          selected: filters.contains(exercise),
                                          onSelected: (bool selected) {
                                            setState(() {
                                              if (selected) {
                                                filters.add(exercise);
                                              } else {
                                                filters.remove(exercise);
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () async {},
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
                                child: const Center(
                                    child: Text(
                                  "Save ",
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
                  );
          }),
    ));
  }
}
