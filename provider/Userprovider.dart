import 'dart:convert';
import 'dart:math';

import 'package:crm_generatewealthapp/Accounting/models/EmployeeModel.dart';
import 'package:crm_generatewealthapp/LoginSIgnup/agentmodel.dart';
import 'package:crm_generatewealthapp/LoginSIgnup/superusermodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/calendarmodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/datetodomodel.dart';
import 'package:crm_generatewealthapp/CRM/contact/contactmodel.dart';
import 'package:crm_generatewealthapp/CRM/customer/customermodel.dart';
import 'package:crm_generatewealthapp/CRM/leads/leadsmodel.dart';
import 'package:crm_generatewealthapp/models/tenant_model.dart';
import 'package:crm_generatewealthapp/models/workspace_model.dart';
import 'package:crm_generatewealthapp/provider/crmapi.dart';
import 'package:crm_generatewealthapp/CRM/search/searchmodel.dart';
import 'package:crm_generatewealthapp/settingsmodel.dart';
import 'package:crm_generatewealthapp/CRM/todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LoginSIgnup/usermodel.dart';
import '../models/user.dart';

class Userprovider with ChangeNotifier {
  List<UserModel>? userdetails;
  
 
  List<SettingsModel>? settings;
  List<EmployeeModel>? Employee_selectedworkspace;
  List<EmployeeModel>? Employees = [];
  List<EmployeeModel>? nouseremployee;
  List<String?> untagged_employeenames = [];

  Map<String, List<EmployeeModel>?> employees_mapping = {};

  bool settingload = false;

 
  User? user;
  List<TenantModel> tenants = [];
  List<WorkspaceModel> workspaces = [];
  WorkspaceModel? selectedworkspace;
  TenantModel? selectedtenant;
  Map<String, List<WorkspaceModel>>? get groupedworkspace {
    if (workspaces.isNotEmpty)
      return groupBy(workspaces, (WorkspaceModel ws) => ws.workspaceid);
    return null;
  }

  // CompanyMenuData? companyMenuData;
  UserModel? userdata;
  bool getuserdata = false;
  
 
 
  bool istenantsfetching = false;
  bool iswsfetching = false;
  bool isempfetching = false;
  bool? insertnote;
  bool empfetch = false;

  bool forgotpwdloading = false;
  String forgotout = '';

  String deflangugage = "English";

  // saveduser(savedData) async {
  //   getuserdata = true;
  //   userdata = await UserModel.fromJson(savedData);
  //   stakeholdertypes?.clear();

  //   if (userdata?.role == 'Agent') {
  //     getagent(userdata?.productlist?.first['productid']);
  //   } else if (userdata?.role == 'SuperUser') {
  //     getsuperuser(userdata?.productlist?.first['productid']);
  //   }

  //   getuserdata = false;
  //   notifyListeners();
  // }

 

  loggeduser(userdata) async {
    user = await User.fromJson(userdata);
    notifyListeners();
  }

  updatelanguage(languagge) {
    deflangugage = languagge;
    notifyListeners();
  }

  logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    userdata = null;
    user = null;
    userdetails = null;
    tenants = [];
    workspaces = [];
    selectedtenant = null;
    selectedworkspace = null;
    notifyListeners();
  }

  authuser(email, password) async {
    try {
      user = await Crmapi.authuser(email, password);
      print(user);
    } catch (e) {
      print(e.toString());
      print("Error in auth user");
      rethrow;
    }
    notifyListeners();
  }

  forgotpassword(emailid) async {
    forgotpwdloading = true;
    forgotout = '';

    try {
      String out = await Crmapi.forgotpassword(emailid);

      forgotout = out;
      forgotpwdloading = false;
      notifyListeners();
    } on Exception catch (e) {
      forgotpwdloading = false;
      notifyListeners();
      print(e.toString());
      // TODO
    }
  }

  setselectedtenant(TenantModel data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tenantstring = jsonEncode(data.toJson());
    await prefs.setString('selectedtenant', (tenantstring));
    selectedtenant = data;
    workspaces = [];
    notifyListeners();
    fetchworkspaces();
  }

  setselectedworkspace(WorkspaceModel data) {
    selectedworkspace = data;
    notifyListeners();
  }

  userfetchemployyes() async {
    try {
      isempfetching = true;
      notifyListeners();

      nouseremployee =
          await Crmapi.userfetchemployees(selectedtenant?.tenantid);
      Employee_selectedworkspace =
          await Crmapi.fetchusermgmt(selectedtenant?.tenantid);

      if (nouseremployee != null) {
        untagged_employeenames = nouseremployee
                ?.where((element) =>
                    (element.UserID == null || element.UserID == ''))
                .map((e) => "${e.FirstName} ${e.LastName}")
                .toList() ??
            [];
        employees_mapping = groupBy(Employee_selectedworkspace!,
            (EmployeeModel obj) => obj.UserID ?? '');
      }
      isempfetching = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      print("Error in fetch employees");
    }
  }

  fetchemployyes() async {
    try {
      empfetch = true;
      notifyListeners();

      Employees = await Crmapi.fetchemployee(selectedtenant?.tenantid);

      empfetch = false;
      notifyListeners();
    } catch (e) {
      empfetch = false;
      notifyListeners();
      print(e.toString());
      print("Error in fetch employees");
    }
  }

  addemployyes(
      Bytesdata,
      filetype,
      EmployeeID,
      FirstName,
      MiddleName,
      LastName,
      PhoneNumber,
      EmailID,
      Gender,
      EmployeeType,
      Status,
      StartDate,
      EndDate) async {
    try {
      empfetch = true;

      bool out = await Crmapi.insertemployee(
          Bytesdata,
          filetype,
          selectedtenant?.tenantid,
          EmployeeID,
          FirstName,
          MiddleName,
          LastName,
          PhoneNumber,
          EmailID,
          Gender,
          EmployeeType,
          Status,
          StartDate,
          EndDate);

      if (out) {
        await fetchemployyes();
        userfetchemployyes();
      }

      empfetch = false;
      notifyListeners();
      return out;
    } catch (e) {
      empfetch = false;
      notifyListeners();
      print(e.toString());
      print("Error in fetch employees");
    }
  }

  updateemployyes(ID, EmployeeID, FirstName, MiddleName, LastName, PhoneNumber,
      EmailID, Gender, EmployeeType, Status, StartDate, EndDate) async {
    try {
      empfetch = true;

      bool out = await Crmapi.updatemeployee(
          ID,
          EmployeeID,
          FirstName,
          MiddleName,
          LastName,
          PhoneNumber,
          EmailID,
          Gender,
          EmployeeType,
          Status,
          StartDate,
          EndDate);

      if (out) {
        await fetchemployyes();
        userfetchemployyes();
      }

      empfetch = false;
      notifyListeners();
      return out;
    } catch (e) {
      empfetch = false;
      notifyListeners();
      print(e.toString());
      print("Error in fetch employees");
    }
  }

  deleteemployyes(ID) async {
    try {
      empfetch = true;

      bool out = await Crmapi.deleteemployee(
        ID,
      );

      if (out) {
        await fetchemployyes();
        userfetchemployyes();
      }

      empfetch = false;
      notifyListeners();
      return out;
    } catch (e) {
      empfetch = false;
      notifyListeners();
      print(e.toString());
      print("Error in fetch employees");
    }
  }

  usermangementaction(
    Create,
    Delete,
    UserID,
    UpdateJson,
    EmailID,
    UserRole,
    PhoneNumber,
    FirstName,
    LastName,
    ID,
  ) async {
    try {
      isempfetching = true;
      notifyListeners();

      bool out = await Crmapi.usermanagementaction(
          Create,
          Delete,
          UserID,
          UpdateJson,
          EmailID,
          selectedtenant?.tenantid,
          UserRole,
          PhoneNumber,
          FirstName,
          LastName,
          ID);
      isempfetching = false;
      notifyListeners();
      if (out) {
        userfetchemployyes();

        return out;
      }
      return false;
    } catch (e) {
      print(e.toString());
      print("Error in usermangementaction");
    }
    isempfetching = false;
    notifyListeners();
  }

  fetchtenants() async {
    istenantsfetching = true;
    notifyListeners();
    if (user != null)
      try {
        tenants = await Crmapi.fetchtenant(user!.userid);

        if (tenants.isNotEmpty) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey('selectedtenant')) {
            final Map<String, dynamic> data =
                jsonDecode(prefs.getString('selectedtenant')!);
            TenantModel tenantinlocal = TenantModel.fromJson(data);
            if (tenants.any((e) => e.tenantid == tenantinlocal.tenantid)) {
              selectedtenant = tenantinlocal;
              fetchworkspaces();
            }
            ;
          }
        }
      } catch (e) {
        print(e.toString());
        print("Error in fetch tenant");
      }
    istenantsfetching = false;
    notifyListeners();
  }

  fetchworkspaces() async {
    iswsfetching = true;
    notifyListeners();
    if (user != null && selectedtenant != null)
      try {
        workspaces =
            await Crmapi.fetchworkspace(user!.userid, selectedtenant!.tenantid);
        if (workspaces.isNotEmpty) {
          setselectedworkspace(workspaces.first);
          userfetchemployyes();
          fetchemployyes();
        }
        // if (workspaces.isNotEmpty) {
        //   final SharedPreferences prefs = await SharedPreferences.getInstance();
        //   if (prefs.containsKey('selectedtenant')) {
        //     final Map<String, dynamic> data =
        //         jsonDecode(prefs.getString('selectedtenant')!);
        //     TenantModel tenantinlocal = TenantModel.fromJson(data);
        //     if (tenants.any((e) => e.tenantid == tenantinlocal.tenantid)) {
        //       selectedtenant = tenantinlocal;
        //     }
        //     ;
        //   }
        // }
      } catch (e) {
        print(e.toString());
        print("Error in fetch workspace");
      }
    iswsfetching = false;
    notifyListeners();
  }

  // getdata(email, password, tenant) async {
  //   getuserdata = true;
  //   stakeholdertypes?.clear();
  //   try {
  //     userdata = await Crmapi.getuser(email, password, tenant);

  //     if (userdata?.role == 'Agent') {
  //       getagent(userdata?.productlist?.first['productid']);
  //     } else if (userdata?.role == 'SuperUser') {
  //       getsuperuser(userdata?.productlist?.first['productid']);
  //     }
  //     getstackholdertypes();
  //     getcustomertabs();

  //     getleadstabs();

  //     calendardata();
  //     tododata();
  //     getuserdata = false;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //     print("Error in getdata");
  //   }
  // }

  vnsettings() async {
    try {
      settingload = true;
      List<SettingsModel>? data;
      data = await Crmapi.loadSettings();
      settings = data;
      settingload = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
