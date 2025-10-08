import 'package:crm_generatewealthapp/CRM/calendar/calendarmodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/datetodomodel.dart';
import 'package:crm_generatewealthapp/CRM/contact/contactmodel.dart';
import 'package:crm_generatewealthapp/CRM/customer/customermodel.dart';
import 'package:crm_generatewealthapp/CRM/leads/leadsmodel.dart';
import 'package:crm_generatewealthapp/CRM/search/searchmodel.dart';
import 'package:crm_generatewealthapp/CRM/todo/todomodel.dart';
import 'package:crm_generatewealthapp/provider/crmapi.dart';
import 'package:crm_generatewealthapp/stackholder/leadsschedulemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Crmprovider with ChangeNotifier{

   List<StakeHolderTypes>? stakeholdertypes;
  List<CustomerSubscription>? customertabs;
  List<Leadsschedulemodel>? leadstabs;
  List<Contacts>? contacts;
  List<Searchmodel>? searchdata;
  List<Customers>? customers;
  List<Leads>? leads;
  List<Todomodel>? todo;
  List<Datetodomodel>? datetodo;
  List<Calendarmodel>? calendar;


  bool getcontactdata = false; 
  bool getcontactnote = false;
  bool getleadsdata = false;
  bool getcustomerdata = false;
  bool getsuperusers = false;
  bool getagents = false;
  bool getodo = false;
  bool getdatetodo = false;
  bool getcalendar = false;
  bool getupdatestack = false;
  bool fetchleadstabs = false;
  bool customerttabs = false;
  bool gettabs = false;
   bool getalldata = false;
  bool imageuploading = false;
   String? s3link;


 fetchalldata(branchid) {
    getallsearchdata(branchid);
    contactsdata(branchid);
    leadsdata(branchid);
    customersdata(branchid);
    getstackholdertypes(branchid);
    getcustomertabs(branchid);
    getleadstabs(branchid);
    calendardata(branchid);
    tododata(branchid);
  }
  
  contactsdata(branchid) async {
    getcontactdata = true;
    contacts?.clear();
    List<Contacts>? cust;

    try {
      cust = await Crmapi.getcontacts(branchid);
      print("contacts successfully");
    } catch (e) {
      print("$e");
    } finally {
      contacts = cust;
      getcontactdata = false;
      notifyListeners();
    }
  }

  leadsdata(branchid) async {
    getleadsdata = true;
    leads?.clear();
    List<Leads>? cust;
    try {
      cust = await Crmapi.getleads(branchid);
    } catch (e) {
      print("$e");
    } finally {
      leads = cust;
      getleadsdata = false;
      notifyListeners();
    }
  }

  customersdata(branchid) async {
    getcustomerdata = true;
    customers?.clear();
    List<Customers>? cust;
    try {
      cust = await Crmapi.getcustomers(branchid);
    } catch (e) {
      print("$e");
    } finally {
      customers = cust;
      getcustomerdata = false;
      notifyListeners();
    }
  }

  insertnotes(
    clientid,
    branchid,
    date,
    content,
    stackholdertype,
  ) async {
    try {
      getcontactnote = true;
      var insertnote = await Crmapi.insertnotes(
          clientid, branchid, date, content);
      if (insertnote) {
        if (stackholdertype == "Customers") {
          await customersdata(branchid);
          getcontactnote = true;
        } else if (stackholdertype == "Leads") {
          await leadsdata(branchid);
          getcontactnote = true;
        } else if (stackholdertype == 'Contacts') {
          await contactsdata(branchid);
          getcontactnote = true;
        }
      }
      getcontactnote = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  updatenotes(
    clientid,
    branchid,
    date,
    content,
    stackholdertype,
    noteid,
  ) async {
    try {
      getcontactnote = true;
    var  insertnote = await Crmapi.updatenotes(
          clientid, branchid, date, content, noteid);
      if (insertnote) {
        if (stackholdertype == "Customers") {
          await customersdata(branchid);
        } else if (stackholdertype == "Leads") {
          await leadsdata(branchid);
        } else if (stackholdertype == 'Contacts') {
          await contactsdata(branchid);
        }
      }
      getcontactnote = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  deletenote(
    stackholdertype,
    noteid,
    branchid
  ) async {
    try {
      getcontactnote = true;
     var insertnote = await Crmapi.deletenote(noteid);
      if (insertnote) {
        if (stackholdertype == "Customers") {
          await customersdata(branchid);
        } else if (stackholdertype == "Leads") {
          await leadsdata(branchid);
        } else if (stackholdertype == 'Contacts') {
          await contactsdata(branchid);
          getcontactnote = true;
        }
      }
      getcontactnote = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // getagent(productid) async {
  //   getagents = true;
  //   List<Agent>? cust;
  //   agentdetails?.clear();
  //   try {
  //     cust = await Crmapi.getagents(
  //         userdata?.agentid, userdata?.tenantid, userdata?.role, productid);

  //     print("get agents success..!");
  //   } catch (e) {
  //     print("$e");
  //   } finally {
  //     agentdetails = cust;
  //     getagents = false;
  //     notifyListeners();
  //   }
  // }

  // getsuperuser(productid) async {
  //   getsuperusers = true;
  //   List<Superuser>? cust;
  //   superuserdetails?.clear();
  //   try {
  //     cust = await Crmapi.getsuperuser(
  //         userdata?.agentid, userdata?.tenantid, userdata?.role, productid);
  //   } catch (e) {
  //     print("$e");
  //   } finally {
  //     superuserdetails = cust;
  //     getsuperusers = false;
  //     notifyListeners();
  //   }
  // }

  tododata(branchid) async {
    getodo = true;
    todo?.clear();
    List<Todomodel>? cust;
    try {
      cust = await Crmapi.gettodo(branchid,
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } catch (e) {
      print("$e");
    } finally {
      todo = cust;
      getodo = false;
      notifyListeners();
    }
  }

  datetododata(date,branchid) async {
    getdatetodo = true;
    datetodo?.clear();
    List<Datetodomodel>? cust;
    try {
      cust = await Crmapi.getdatetodo( date,branchid);
      print(date);
    } catch (e) {
      print("$e");
    } finally {
      datetodo = cust;
      getdatetodo = false;
      notifyListeners();
    }
  }

  calendardata(branchid) async {
    getcalendar = true;
    List<Calendarmodel>? cust;
    try {
      cust = await Crmapi.getcalendar(branchid);
    } catch (e) {
      print("$e");
    } finally {
      calendar = cust;
      getcalendar = false;
      notifyListeners();
    }
  }

  updatestack(stakeholdertype, branchid,clientid, status) async {
    getupdatestack = true;
    try {
      await Crmapi.updatestack(
          stakeholdertype, branchid, clientid, status);
    } catch (e) {
      print("$e");
    } finally {
      getupdatestack = false;
      notifyListeners();
    }
  }

  addcontact(branchid,name, email, phone, addressline1, city, state, pincode, country,
      tag) async {
    getcontactdata = true;
    contacts?.clear();
    List<Contacts>? cust;
    try {
      cust = await Crmapi.insertcontact(
        branchid, name,
          email, phone, addressline1, city, state, pincode, country, tag);
      print("contacts successfully");
    } catch (e) {
      print("$e");
    } finally {
      contacts = cust;
      getcontactdata = false;
      notifyListeners();
    }
  }

  addcontactcsv(agentid, branchid,role, productid, bytes, filetype) async {
    getcontactdata = true;
    contacts?.clear();
    List<Contacts>? cust;
    try {
      cust = await Crmapi.insertcontactcsv(
          agentid, branchid, productid, role, bytes, filetype);
      print("contacts successfully");
    } catch (e) {
      print("$e");
    } finally {
      contacts = cust;
      getcontactdata = false;
      notifyListeners();
    }
  }

  getleadstabs(branchid) async {
    fetchleadstabs = true;
    leadstabs?.clear();
    List<Leadsschedulemodel>? cust;
    try {
      cust = await Crmapi.getleadstabs(branchid);
      print("Leadstabs successfully");
    } catch (e) {
      print("$e");
    } finally {
      fetchleadstabs = false;
      leadstabs = cust;
      notifyListeners();
    }
  }

  getstackholdertypes(branchid) async {
    gettabs = true;
    stakeholdertypes?.clear();
    List<StakeHolderTypes>? cust;
    try {
      cust = await Crmapi.getstackholdertypes(branchid);
      print("getstackholdertypes successfully");
    } catch (e) {
      print("$e");
    } finally {
      gettabs = false;
      stakeholdertypes = cust;
      notifyListeners();
    }
  }

  getcustomertabs(branchid) async {
    customerttabs = true;
    List<CustomerSubscription>? cust;
    try {
      cust = await Crmapi.getcustomertabs(branchid);
      print("getcustomertabs successfully");
    } catch (e) {
      print("$e");
    } finally {
      customertabs = cust;
      customerttabs = false;
      notifyListeners();
    }
  }

  editsingle(
      clientid,
      branchid,
      dnd,
      name,
      email,
      actiontype,
      nextmsgdate,
      lastmsgdate,
      phone,
      addressline1,
      city,
      state,
      pincode,
      country,
      tag,
      stakeholdertype) async {
    bool? cust;
    try {
      cust = await Crmapi.editsingle(
          clientid,
          branchid,
          
          dnd,
          name,
          email,
          actiontype,
          nextmsgdate,
          lastmsgdate,
          phone,
          addressline1,
          city,
          state,
          pincode,
          country,
          tag);
    } catch (e) {
      print("$e");
    } finally {
      if (cust!) {
        if (stakeholdertype == 'Contacts') {
          await contactsdata(branchid);
          calendardata(branchid);
          tododata(branchid);
        } else if (stakeholdertype == 'Leads') {
          await leadsdata(branchid);
          calendardata(branchid);
          tododata(branchid);
        } else if (stakeholdertype == 'Customers') {
          await customersdata(branchid);
          calendardata(branchid);
          tododata(branchid);
        } else if (stakeholdertype == 'Todo') {
          await tododata(branchid);
          calendardata(branchid);
        } else if (stakeholdertype == 'Calendar') {
          await calendardata(branchid);
          tododata(branchid);
          // await getcalendar();
        } else if (stakeholdertype == 'Search') {
          await getallsearchdata(branchid);
          calendardata(branchid);
          tododata(branchid);
        }
      }

      notifyListeners();
    }
  }

  changeleadsstatus(
    clientid,
    branchid,
    statustype,
  ) async {
    try {
      await Crmapi.changeleadsstatus(
          clientid, branchid, statustype);

      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  changecuststatus(
    clientid,
    branchid,
    subscriptiontype,
  ) async {
    try {
      await Crmapi.changecuststatus(
          clientid,  branchid,subscriptiontype);

      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  getallsearchdata(branchid) async {
    getalldata = true;

    List<Searchmodel>? searchdataapi;

    try {
      searchdataapi = await Crmapi.getalldata(branchid);
      print("searchdata successfully");
    } catch (e) {
      print("$e");
    } finally {
      searchdata = searchdataapi;
      getalldata = false;
      notifyListeners();
    }
  }

  uploadimageins3(imagebasecode, eventdate, extension, imagename) async {
    imageuploading = true;
    s3link = null;
    String? outlink;
    try {
      outlink = await Crmapi.uploads3image(
          imagebasecode, eventdate, extension, imagename);
    } catch (e) {
      print("$e");
    } finally {
      s3link = outlink;
      imageuploading = false;
      notifyListeners();
    }
  }

  postponetodo(clientid, branchid, postponeddate) async {
    try {
      await Crmapi.postponetodo(clientid, branchid, postponeddate);

      await tododata(branchid);
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }


}