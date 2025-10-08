import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Employeeaction extends StatefulWidget {
  bool edit;
  String? firstname;
  String? middlename;
  String? lasename;
  String? gender;
  String? email;
  String? phone;
  String? employeetype;
  String? employeeid;
  String? status;
  String? startdate;
  String? enddate;
  String? id;
  Employeeaction(
      {super.key,
      required this.edit,
      this.id,
      this.email,
      this.employeeid,
      this.enddate,
      this.firstname,
      this.gender,
      this.lasename,
      this.middlename,
      this.employeetype,
      this.phone,
      this.startdate,
      this.status});

  @override
  State<Employeeaction> createState() => _EmployeeactionState();
}

class _EmployeeactionState extends State<Employeeaction> {
  @override
  void initState() {
    if (widget.edit) {
      firstname.text = widget.firstname ?? '';
      middlename.text = widget.middlename ?? '';
      email.text = widget.email ?? '';
      phonenumber.text = widget.phone ?? '';
      lastname.text = widget.lasename ?? '';
      EmployeeID.text = widget.employeeid ?? '';
      gender = widget.gender ?? "Male";
      emptype = widget.employeetype ?? "Staff";
      Status = widget.status ?? "Active";
      startdate = widget.startdate != null
          ? DateTime.tryParse(widget.startdate!)
          : null;
      enddate =
          widget.enddate != null ? DateTime.tryParse(widget.enddate!) : null;
    }
    // TODO: implement initState
    super.initState();
  }

  late Userprovider _userprovider;
  late ThemeData currentTheme;

  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController EmployeeID = TextEditingController();

  DateTime? startdate;
  DateTime? enddate;

  DateTime? selectedStDate;
  DateTime? selectedEdDate;

  String gender = "Male";
  String emptype = "Staff";
  String Status = "Active";

  final _formkey = GlobalKey<FormState>();

  Widget _buildInputField(
      String label,
      // Function(String?) onSaved,
      TextEditingController controller,
      IconData icon,
      currentTheme,
      {TextInputType? keyboardType,
      onchanged,
      bool? isnotvalidate,
      bool split = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: split
            ? MediaQuery.of(context).size.width / 2.155
            : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onchanged,
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
          maxLines: label == 'Address' ? 4 : 1,
          keyboardType: keyboardType,
          validator: (value) {
            if (isnotvalidate ?? false) {
              return null;
            } else if (label == 'Email *') {
              if (value == null || value.isEmpty) {
                return 'Please enter some value..!';
              } else if (value.isNotEmpty) {
                final bool isValid = EmailValidator.validate(email.text);
                if (!isValid) {
                  return "Please Enter Valid Email..!";
                } else {
                  return null;
                }
              }
            } else if (value == null || value.isEmpty) {
              return 'Please enter some value..!';
            }
            return null;
          },
        ),
      ),
    );
  }

  Future<void> selectStartDate(BuildContext context, currentTheme) async {
    selectedStDate = await showDatePicker(
      context: context,
      initialDate: startdate ?? DateTime.now(),
      firstDate: DateTime(2000),
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
      startdate = selectedStDate ?? DateTime.now();
    });
  }

  Future<void> selectEndDate(BuildContext context, currentTheme) async {
    selectedEdDate = await showDatePicker(
      context: context,
      initialDate: enddate ?? DateTime.now(),
      firstDate: DateTime(2025),
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
      enddate = selectedEdDate ?? DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    currentTheme = context.watchtheme.currentTheme;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("Employee_title"),
        ),
        backgroundColor: Color.fromARGB(255, 74, 63, 221),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildInputField(
                '${AppLocalizations.of(context).translate("FirstName")} *',
                firstname,
                Icons.person,
                Theme.of(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInputField(
                      '${AppLocalizations.of(context).translate("MiddleName")}',
                      middlename,
                      Icons.person,
                      Theme.of(context),
                      isnotvalidate: true,
                      split: true),
                  _buildInputField(
                      '${AppLocalizations.of(context).translate("LastName")} *',
                      lastname,
                      Icons.person,
                      Theme.of(context),
                      split: true),
                ],
              ),
              _buildInputField(
                  '${AppLocalizations.of(context).translate("EmployeeID")}',
                  EmployeeID,
                  Icons.numbers,
                  Theme.of(context),
                  isnotvalidate: true),
              _buildInputField(
                  '${AppLocalizations.of(context).translate("Email")} *',
                  email,
                  Icons.email,
                  Theme.of(context)),
              _buildInputField(
                '${AppLocalizations.of(context).translate("PhoneNumber")} *',
                phonenumber,
                Icons.phone,
                Theme.of(context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                            ),
                            child:
                                Icon(Icons.check_circle, color: Colors.indigo),
                          ),
                          Text(
                              "${AppLocalizations.of(context).translate("EmployeeType")}",
                              style: currentTheme.textTheme.displayMedium
                                  ?.copyWith(color: Colors.indigo)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 20, top: 7, bottom: 7),
                      child: DropdownButton<String>(
                        value: emptype,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        elevation: 16,
                        // style: const TextStyle(color: Colors.deepPurple),
                        // underline: Container(height: 2, color: Colors.deepPurpleAccent),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            emptype = value!;
                          });
                        },
                        items: ["Staff", "Manager", "Owner", "Approver"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8, top: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                    ),
                                    child: Icon(Icons.person,
                                        color: Colors.indigo),
                                  ),
                                  Text(
                                      "${AppLocalizations.of(context).translate("Gender")}",
                                      style: currentTheme
                                          .textTheme.displayMedium
                                          ?.copyWith(color: Colors.indigo)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: DropdownButton<String>(
                                  value: gender,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: 16,
                                  // style: const TextStyle(color: Colors.deepPurple),
                                  // underline: Container(height: 2, color: Colors.deepPurpleAccent),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                  items: ["Male", "Female", "other"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value, child: Text(value));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8, top: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                    ),
                                    child: Icon(Icons.check_circle,
                                        color: Colors.indigo),
                                  ),
                                  Text(
                                      "${AppLocalizations.of(context).translate("Status")}",
                                      style: currentTheme
                                          .textTheme.displayMedium
                                          ?.copyWith(color: Colors.indigo)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: DropdownButton<String>(
                                  value: Status,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: 16,
                                  // style: const TextStyle(color: Colors.deepPurple),
                                  // underline: Container(height: 2, color: Colors.deepPurpleAccent),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      Status = value!;
                                    });
                                  },
                                  items: ["Active", "Inactive"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value, child: Text(value));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      selectStartDate(context, currentTheme);
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: currentTheme.primaryColor,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).translate("StartDate")}",
                                style: currentTheme.textTheme.displayMedium
                                    ?.copyWith(
                                        color: currentTheme.primaryColor),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                DateFormat('dd MMM yyyy')
                                    .format(startdate ?? DateTime.now())
                                    .toString(),
                                style: TextStyle(
                                    color: currentTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      selectStartDate(context, currentTheme);
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: currentTheme.primaryColor,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).translate("EndDate")}",
                                style: currentTheme.textTheme.displayMedium
                                    ?.copyWith(
                                        color: currentTheme.primaryColor),
                              ),
                            ],
                          ),
                          enddate == null
                              ? IconButton(
                                  onPressed: () {
                                    selectEndDate(context, currentTheme);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo,
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(enddate ?? DateTime.now())
                                          .toString(),
                                      style: TextStyle(
                                          color: currentTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    if (!widget.edit) {
                      try {
                        context.loaderOverlay.show();
                        bool out = await _userprovider.addemployyes(
                            null,
                            null,
                            EmployeeID.text,
                            firstname.text,
                            middlename.text,
                            lastname.text,
                            phonenumber.text,
                            email.text,
                            gender,
                            emptype,
                            Status,
                            DateFormat('yyyy-MM-dd')
                                .format(startdate ?? DateTime.now()),
                            enddate != null
                                ? DateFormat('yyyy-MM-dd').format(enddate!)
                                : null);
                        context.loaderOverlay.hide();

                        if (out) {
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
                    } else {
                      if (firstname.text == widget.firstname &&
                              middlename.text == widget.middlename &&
                              email.text == widget.email &&
                              phonenumber.text == widget.phone &&
                              lastname.text == widget.lasename &&
                              EmployeeID.text == widget.employeeid &&
                              gender == widget.gender &&
                              emptype == widget.employeetype &&
                              Status == widget.status &&
                              DateFormat('yyyy-MM-dd')
                                      .format(startdate ?? DateTime.now()) ==
                                  widget.startdate &&
                              (enddate != null
                                  ? DateFormat('yyyy-MM-dd').format(enddate!) ==
                                      widget.enddate
                                  : enddate == widget.enddate)

                          // enddate ==
                          //     widget.enddate != null ? DateTime.tryParse(widget.enddate!) : null
                          ) {
                        const snackBar = SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text("Please make changes"),
                            backgroundColor: Colors.red);

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        try {
                          context.loaderOverlay.show();
                          bool out = await _userprovider.updateemployyes(
                              widget.id,
                              EmployeeID.text,
                              firstname.text,
                              middlename.text,
                              lastname.text,
                              phonenumber.text,
                              email.text,
                              gender,
                              emptype,
                              Status,
                              DateFormat('yyyy-MM-dd')
                                  .format(startdate ?? DateTime.now()),
                              enddate != null
                                  ? DateFormat('yyyy-MM-dd').format(enddate!)
                                  : null);
                          context.loaderOverlay.hide();

                          if (out) {
                            context.loaderOverlay.hide();
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Success"),
                                backgroundColor: Colors.green);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Navigator.pop(context, true);
                          } else {
                            context.loaderOverlay.hide();
                            const snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Failed"),
                                backgroundColor: Colors.red);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          }
                        } on Exception catch (e) {
                          print(e.toString());
                          context.loaderOverlay.show();
                          // TODO
                        }
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, bottom: 10, left: 10, top: 22),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        !widget.edit
                            ? "${AppLocalizations.of(context).translate("Submit")}"
                            : "${AppLocalizations.of(context).translate("Save")}",
                        style: currentTheme.textTheme.displayLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    ));
  }
}
