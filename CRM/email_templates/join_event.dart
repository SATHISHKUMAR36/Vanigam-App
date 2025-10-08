import 'package:crm_generatewealthapp/main.dart' show AppLocalizations;
import 'package:crm_generatewealthapp/provider/crmapi.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class JoinEvent extends StatefulWidget {
  List emails;
   JoinEvent({super.key,required this.emails});

  @override
  State<JoinEvent> createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {
  
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
          } else if (link &&
              !value.contains('http')) {
            return 'Please enter link only';
          }
          return null;
        },
        // onSaved: onSaved,
      ),
    );
  }

TimeOfDay _time = TimeOfDay.now(); 
  TimeOfDay? picked; 
  
  Future<Null> selectTime(BuildContext context,currentTheme) async { 
    picked = await showTimePicker( 
      context: context, 
      initialTime: _time, 
      builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:  currentTheme.primaryColor,// header background color
              ),
            ),
            child: child!,
          );}
    ); 

    setState(() { 
      _time = picked ?? TimeOfDay.now(); 
  
      print(picked);  
    }); 
  } 
  DateTime? selectedDate;
   DateTime? currentdate = DateTime.now();

      Future<void> selectDate(BuildContext context,currentTheme) async {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: currentdate ?? DateTime.now(),
        firstDate: DateTime(2023),
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
        currentdate = selectedDate ?? DateTime.now();
      });
    }


  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController altheader = TextEditingController();
    TextEditingController subject = TextEditingController();
  TextEditingController meetplatform = TextEditingController();
  TextEditingController meetid = TextEditingController();
  TextEditingController passcode = TextEditingController();
  TextEditingController ctalink = TextEditingController();
  TextEditingController ctabuttonname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(child: Scaffold(appBar: AppBar(
      title: Text("${AppLocalizations.of(context).translate("Join_event_mail")}"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        backgroundColor: currentTheme.primaryColor,
    ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child:
                    _buildInputField('${AppLocalizations.of(context).translate("Title")}', title, false,Icons.mail, currentTheme)),
                    Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField(
                    '${AppLocalizations.of(context).translate("Subject")}', subject,false, Icons.horizontal_split, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField(
                    '${AppLocalizations.of(context).translate("AltSubject")}', altheader,false, Icons.list_alt_rounded, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField(
                    '${AppLocalizations.of(context).translate("Meetplatform")}', meetplatform,false, Icons.language, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField(
                    '${AppLocalizations.of(context).translate("MeetingID")}', meetid,false, Icons.numbers, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField('${AppLocalizations.of(context).translate("Passcode")}', passcode,false,
                    Icons.password, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField(
                    '${AppLocalizations.of(context).translate("CTAlink")}', ctalink,true, Icons.insert_link, currentTheme)

                // horizontal_split
                // list_alt_rounded
                ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: _buildInputField('${AppLocalizations.of(context).translate("CTAname")}', ctabuttonname,false,
                    Icons.indeterminate_check_box, currentTheme)

                
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                         selectDate(context,currentTheme);
                      },
                      child: Container(
                        height: 50,width:MediaQuery.of(context).size.width/2.15,
                        decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.calendar_month,color: currentTheme.primaryColor,),
                            ),
                            Center(
                              child: Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(currentdate ?? DateTime.now())
                                    .toString(),
                                style: TextStyle(
                                    color: currentTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ), 
                    ),
                    InkWell(
                      onTap: () {
                        selectTime(context,currentTheme);
                      },
                      child: Container(
                        height: 50,width:MediaQuery.of(context).size.width/2.15,
                        decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.access_time_outlined ,color: currentTheme.primaryColor,),
                            ),Center(
                              child: Text(
                             '${_time.hour}:${_time.minute}',
                                style: TextStyle(
                                    color: currentTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
            
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 20),
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
                        "${AppLocalizations.of(context).translate("SendEmail")}",
                        style: TextStyle(
                            color: currentTheme.canvasColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        
                        bool event= await Crmapi.joinmail(subject.text,widget.emails,title.text,altheader.text,DateFormat("yyyy-MM-dd").format(currentdate??DateTime.now().add(const Duration(days: 2))),'${_time.hour}:${_time.minute} ${_time.period.name}',meetplatform.text,ctalink.text,meetid.text,passcode.text,ctabuttonname.text,"xcaldata");
                        context.loaderOverlay.hide();
                
                if(event){
                  final snackBar =  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                            "${AppLocalizations.of(context).translate("Success")}"),
                                    backgroundColor: Colors.green);


                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pop(context);

                }else{
                   final snackBar =  SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                            "${AppLocalizations.of(context).translate("Failed")}"),
                                    backgroundColor: Colors.red);


                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pop(context);
                }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    
    ),);
  }
}