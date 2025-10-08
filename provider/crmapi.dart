import 'dart:convert';

import 'package:crm_generatewealthapp/Accounting/models/EmployeeModel.dart';
import 'package:crm_generatewealthapp/Accounting/models/GstReports/GSTmainmodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/accountbanks.dart';
import 'package:crm_generatewealthapp/Accounting/models/bankmaster.dart';
import 'package:crm_generatewealthapp/Accounting/models/banktransactions.dart';
import 'package:crm_generatewealthapp/Accounting/models/ifscbranches.dart';
import 'package:crm_generatewealthapp/Accounting/models/invoicereportsmodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/ledgerhistorymodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/payable.dart';
import 'package:crm_generatewealthapp/Accounting/models/productmaster_model.dart';
import 'package:crm_generatewealthapp/Accounting/models/purchase.dart';
import 'package:crm_generatewealthapp/Accounting/models/recivable.dart';
import 'package:crm_generatewealthapp/Accounting/models/reportsview/reportsinvoicemodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/sales.dart';
import 'package:crm_generatewealthapp/LoginSIgnup/agentmodel.dart';
import 'package:crm_generatewealthapp/LoginSIgnup/superusermodel.dart';
import 'package:crm_generatewealthapp/LoginSIgnup/usermodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/accustomermodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/calendarmodel.dart';
import 'package:crm_generatewealthapp/CRM/calendar/datetodomodel.dart';
import 'package:crm_generatewealthapp/CRM/contact/contactmodel.dart';
import 'package:crm_generatewealthapp/CRM/customer/customermodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/invoicemodel/invoicemodel.dart';
import 'package:crm_generatewealthapp/CRM/leads/leadsmodel.dart';
import 'package:crm_generatewealthapp/models/tenant_model.dart';
import 'package:crm_generatewealthapp/models/workspace_model.dart';
import 'package:crm_generatewealthapp/CRM/search/searchmodel.dart';
import 'package:crm_generatewealthapp/settingsmodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/stockmodel.dart';
import 'package:crm_generatewealthapp/CRM/todo/todomodel.dart';
import 'package:crm_generatewealthapp/Accounting/models/vendormodel.dart';
import 'package:crm_generatewealthapp/stackholder/leadsschedulemodel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../common/constant.dart';
import '../models/user.dart';

class Crmapi {
  static Future<User> authuser(String? email, String? password) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/user/login');
    Map<String, dynamic> body = {"email": email, "password": password};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return User.fromJson(jsonData);
      }
      return Future.error("Error in user login status code error");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Exception in user login");
    }
  }

  static Future<UserModel> getuser(
      String? email, String? password, String? tenant) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/user/login');
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "tenant_name": tenant
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return UserModel.fromJson(jsonData);
      }
      return Future.error("Error in user login");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in user login");
    }
  }

  static Future<List<TenantModel>> fetchtenant(String userid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/fetchtenant');
    Map<String, dynamic> body = {"userid": userid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => TenantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in fetch tenant");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Exception in fetch tenant");
    }
  }

  static Future<List<WorkspaceModel>> fetchworkspace(
      String userid, String tenantid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/fetchworkspace');
    Map<String, dynamic> body = {"userid": userid, "tenantid": tenantid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => WorkspaceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in fetch workspace");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Exception in fetch workspace");
    }
  }

  static Future<bool> eventmail(subject, email, title, header_image_link,
      alt_header, mid_image_link, cta_link, cta_button_name, platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Event_Alert",
      "subject": subject,
      "title": title,
      "email": email,
      "header_image_link": header_image_link,
      "alt_header": alt_header,
      "mid_image_link": mid_image_link,
      "cta_link": cta_link,
      "cta_button_name": cta_button_name,
      "platform": platform
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail");
    }
  }

  static Future<String> previeweventmail(
      subject,
      email,
      title,
      header_image_link,
      alt_header,
      mid_image_link,
      cta_link,
      cta_button_name,
      platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Event_Alert",
      "subject": subject,
      "title": title,
      "email": email,
      "header_image_link": header_image_link,
      "alt_header": alt_header,
      "mid_image_link": mid_image_link,
      "cta_link": cta_link,
      "cta_button_name": cta_button_name,
      "platform": platform,
      "preview": "Yes"
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success preview");

        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData['body'];
      }
      return '';
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail preview");
    }
  }

  static Future<bool> joinmail(
      subject,
      email,
      title,
      alt_header,
      date,
      time,
      meet_platform,
      cta_link,
      meeting_id,
      passcode,
      cta_button_name,
      platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Join_Event",
      "subject": subject,
      "email": email,
      "title": title,
      "alt_header": alt_header,
      "date": date,
      "time": time,
      "meet_platform": meet_platform,
      "meeting_id": meeting_id,
      "passcode": passcode,
      "cta_link": cta_link,
      "cta_button_name": cta_button_name,
      "platform": platform
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail");
    }
  }

  static Future<bool> custommail(subject, email, htmlbody, platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Custom",
      "subject": subject,
      "email": email,
      "body": htmlbody,
      "platform": platform
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail");
    }
  }

  static Future<bool> thankumail(subject, email, header_logo_link, title,
      alt_header, center_text, platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Thank_You",
      "subject": subject,
      "email": email,
      "header_logo_link": header_logo_link,
      "title": title,
      "alt_header": alt_header,
      "center_text": center_text,
      "platform": platform,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail");
    }
  }

  static Future<String> previewthankumail(subject, email, header_logo_link,
      title, alt_header, center_text, platform) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/email/template');
    Map<String, dynamic> body = {
      "template": "Thank_You",
      "subject": subject,
      "email": email,
      "header_logo_link": header_logo_link,
      "title": title,
      "alt_header": alt_header,
      "center_text": center_text,
      "platform": platform,
      "preview": "Yes"
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData['body'];
      }
      return '';
    } catch (e) {
      print(e);

      throw Exception("Error in Event mail");
    }
  }

  static Future<List<Contacts>> getcontacts(String? branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/data');
    Map<String, dynamic> body = {"branchid": branchid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Contacts.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getcontacts");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getcontacts");
    }
  }

  static Future<List<Searchmodel>> getalldata(String? branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/search/clients/data');
    Map<String, dynamic> body = {"branchid": branchid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Searchmodel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getcontacts");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getcontacts");
    }
  }

  static Future<List<Leads>> getleads(String? branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/leads/data');
    Map<String, dynamic> body = {"branchid": branchid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Leads.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getleads");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getleads");
    }
  }

  static Future<List<Customers>> getcustomers(String? branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/customers/data');
    Map<String, dynamic> body = {"branchid": branchid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Customers.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getcustomers");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getcustomers");
    }
  }

  static Future<bool> insertnotes(clientid, branchid, date, content) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/notes');

    final Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "date": date,
      "content": content
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        return true;
      }
      return false;
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  insert notes");
    }
  }

  static Future<bool> updatenotes(
      clientid, branchid, date, content, noteid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/notes');

    final Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "date": date,
      "content": content,
      "noteid": noteid
    };
    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        return true;
      }
      return false;
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  update notes");
    }
  }

  static Future<bool> deletenote(noteid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/notes');
    final Map<String, dynamic> body = {"noteid": noteid};
    try {
      var response = await http.delete(url, body: json.encode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception("Error in  delete notes");
    }
  }

  static Future<List<Agent>> getagents(String? agentid, String? tenantid,
      String? role, String? productid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/child/data');
    Map<String, dynamic> body = {
      "agentid": agentid,
      "tenantid": tenantid,
      "role": role,
      "productid": productid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Agent.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return Future.error("Error in getagents");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getagents");
    }
  }

  static Future<List<Superuser>> getsuperuser(String? agentid, String? tenantid,
      String? role, String? productid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/child/data');
    Map<String, dynamic> body = {
      "agentid": agentid,
      "tenantid": tenantid,
      "role": role,
      "productid": productid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Superuser.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return Future.error("Error in Superuser");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  Superuser");
    }
  }

  static Future<List<Todomodel>> gettodo(String? branchid, String? date) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/calendar/todo/data');
    Map<String, dynamic> body = {"branchid": branchid, "date": date};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Todomodel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in gettodo");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  gettodo");
    }
  }

  static Future<List<Datetodomodel>> getdatetodo(
      String? branchid, String? date) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/calendar/todo/data');
    Map<String, dynamic> body = {"branchid": branchid, "date": date};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Datetodomodel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in gettodo");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  gettodo");
    }
  }

  static Future<List<Calendarmodel>> getcalendar(
    String? branchid,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/calendar/stakecount/data');
    Map<String, dynamic> body = {
      "branchid": branchid,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Calendarmodel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in Calendarmodel");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  Calendarmodel");
    }
  }

  static updatestack(String? stakeholdertype, String? branchid, List? clientid,
      String? status) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/status/update/stakeholdertype');
    Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "stakeholdertype": stakeholdertype,
      if (status!.isNotEmpty) "status": status
    };
    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);

        return true;
      }
      return Future.error("Error in updatestack");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  updatestack");
    }
  }

  static Future<List<Contacts>> insertcontact(
      String? branchid,
      String? name,
      String? email,
      String? phone,
      String? addressline1,
      String? city,
      String? state,
      String? pincode,
      String? country,
      String? tag) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/insert');
    Map<String, dynamic> body = {
      "branchid": branchid,
      "StakeHolderType": "Contacts",
      "Name": name,
      "Email": email,
      "PhoneNumber": phone,
      "AddressLineOne": addressline1,
      "City": city,
      "State": state,
      "Pincode": pincode,
      "Country": country,
      "Tag": tag
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return getcontacts(branchid);
      }
      return Future.error("Error in insert contacts");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  insert contacts");
    }
  }

  static Future<List<Contacts>> insertcontactcsv(
      String? agentid,
      String? branchid,
      String? productid,
      String? role,
      String? contactsdata,
      String filetype) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/contacts/insert');
    Map<String, dynamic> body = {
      "AgentID": agentid,
      "BranchID": branchid,
      "StakeHolderType": "Contacts",
      "ProductID": productid,
      "Role": role,
      "contactsdata": contactsdata,
      "filetype": filetype
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        return getcontacts(
          branchid,
        );
      }
      return Future.error("Error in insert contacts");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  insert contacts");
    }
  }

  static Future<List<Leadsschedulemodel>> getleadstabs(String? branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/mscode/data');
    Map<String, dynamic> body = {
      "branchid": branchid,
      "codetype": "Lead_Schedule_Status",
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => Leadsschedulemodel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getleadstabs");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  getleadstabs");
    }
  }

  static Future<List<StakeHolderTypes>> getstackholdertypes(
    String? branchid,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/mscode/data');
    Map<String, dynamic> body = {
      "branchid": branchid,
      "codetype": "StakeHolder_Types"
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => StakeHolderTypes.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in StakeHolderTypes");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  StakeHolderTypes");
    }
  }

  static Future<List<CustomerSubscription>> getcustomertabs(
    String? branchid,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/mscode/data');
    Map<String, dynamic> body = {
      "branchid": branchid,
      "codetype": "Customer_Subscription",
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map(
                (e) => CustomerSubscription.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in Customer_Subscription");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  Customer_Subscription");
    }
  }

  static Future<bool> editsingle(
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
      tag) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/update/client/data');
    Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "dnd": dnd,
      "name": name,
      "email": email,
      "actiontype": actiontype,
      "nextmsgdate": nextmsgdate,
      "phonenumber": phone,
      "addresslineone": addressline1,
      "city": city,
      "state": state,
      "pincode": pincode,
      "country": country,
      "tag": tag,
    };

    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        // List<dynamic> jsonData = jsonDecode(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<bool> changeleadsstatus(
    clientid,
    branchid,
    statustype,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/update/client/lead/status');
    Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "statustype": statustype,
    };

    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<bool> changecuststatus(
      clientid, branchid, subscriptiontype) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/update/client/customers/status');
    Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "subscriptiontype": subscriptiontype,
    };

    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<String?> uploads3image(
      imagebasecode, eventdate, extension, imagename) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/mail/image/upload');
    Map<String, dynamic> body = {
      "imagebasecode": imagebasecode,
      "eventdate": eventdate,
      "extension": extension,
      "imagename": imagename,
    };

    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData['link'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> postponetodo(clientid, branchid, postponeddate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/update/client/todo/postpone');
    Map<String, dynamic> body = {
      "clientid": clientid,
      "branchid": branchid,
      "postponeddate": postponeddate
    };

    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<Invoicemodel> invoicedataextraction(
    String? bytesimage,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/invoiceextraction');
    Map<String, dynamic> body = {
      "bytesimage": bytesimage,
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Invoicemodel.fromJson(
            jsonData['extracted_data'] as Map<String, dynamic>);
      }
      return Future.error("Error in invoicedataextraction");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  invoicedataextraction");
    }
  }

  static Future<ReportsInvoice> reportwiseinvoice(
    String? InvoiceID,
    TranscationType,
    TenantID,
    WorkspaceID,
    BranchID,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/invoicedetails');
    Map<String, dynamic> body = {
      "InvoiceID": InvoiceID,
      "TranscationType": TranscationType,
      "TenantID": TenantID,
      "WorkspaceID": WorkspaceID,
      "BranchID": BranchID
    };
    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return ReportsInvoice.fromJson(jsonData);
      }
      return Future.error("Error in ReportsInvoice");
    } on Exception catch (e) {
      print(e.toString());
      throw Exception("Error in  ReportsInvoice");
    }
  }

  static Future<bool> insertinvoice(
      TranactionType,
      VendorID,
      CustomerID,
      Name,
      Address,
      PhoneNumber,
      EmailID,
      ContactPerson,
      GstNumber,
      PanNumber,
      TenantID,
      WorkspaceID,
      BranchID,
      CreditTerms,
      CreditLimit,
      CreditDays,
      Extras,
      InvoiceNumber,
      InvoiceDate,
      InvoiceImage,
      TaxableAmount,
      GSTPercent,
      SGST,
      CGST,
      IGST,
      OtherCharges,
      Discount,
      Items,
      TotalAmount,
      TransportName,
      VehicleNumber,
      EwayNumber,
      EwayDate,
      TransportMode,
      PaymentStatus) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/insertinvoice');
    Map<String, dynamic> body = {
      "TranactionType": TranactionType,
      "VendorID": VendorID,
      "CustomerID": CustomerID,
      "Name": Name,
      "Address": Address,
      "PhoneNumber": PhoneNumber,
      "EmailID": EmailID,
      "ContactPerson": ContactPerson,
      "GstNumber": GstNumber,
      "PanNumber": PanNumber,
      "TenantID": TenantID,
      "WorkspaceID": WorkspaceID,
      "BranchID": BranchID,
      "CreditTerms": CreditTerms,
      "CreditDays": CreditDays,
      "CreditLimit": CreditLimit,
      "Extras": Extras,
      "InvoiceNumber": InvoiceNumber,
      "InvoiceDate": InvoiceDate,
      "InvoiceImage": InvoiceImage,
      "TaxableAmount": TaxableAmount,
      "GSTPercent": GSTPercent,
      "SGST": SGST,
      "CGST": CGST,
      "IGST": IGST,
      "OtherCharges": OtherCharges,
      "Discount": Discount,
      "Items": Items,
      "TotalAmount": TotalAmount,
      "TransportName": TransportName,
      "VehicleNumber": VehicleNumber,
      "EwayNumber": EwayNumber,
      "EwayDate": EwayDate,
      "TransportMode": TransportMode,
      "PaymentStatus": PaymentStatus
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in insertinvoice mail");
    }
  }

  static Future<List<Vendormodel>> getvendors(
      Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/vendordetails');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": branchid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => Vendormodel.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getvendors");
    } catch (e) {
      print(e);

      throw Exception("Error in getvendors");
    }
  }

  static Future<List<AcCustomermodel>> getaccustomers(
      Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/customeracdetails');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": branchid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map((e) => AcCustomermodel.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in getaccustomer");
    } catch (e) {
      print(e);
      throw Exception("Error in getaccustomer");
    }
  }

  static Future<List<Stock>> getstocks(Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/stockdetails');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": branchid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => Stock.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in Stock");
    } catch (e) {
      print(e);
      throw Exception("Error in Stock");
    }
  }

  static Future<List<Ledgerhistory>> getledger(
      Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/actransactionhistory');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": branchid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => Ledgerhistory.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in Stock");
    } catch (e) {
      print(e);
      throw Exception("Error in Stock");
    }
  }

  static exportemail(userid, fromdate, todate, Tenantid, Workspaceid, BranchID,
      FileName, TenantName) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/exportemail');
    Map<String, dynamic> body = {
      "UserID": userid,
      "fromdate": fromdate,
      "todate": todate,
      "FileName": FileName,
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": BranchID,
      "TenantName": TenantName
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        // List<dynamic> jsonData = jsonDecode(response.body);
        print(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw Exception("Error in exportemail crmapi");
    }
  }

  static Future<bool> insertvendor(
      TranactionType,
      Name,
      Address,
      PhoneNumber,
      EmailID,
      ContactPerson,
      GstNumber,
      PanNumber,
      TenantID,
      WorkspaceID,
      BranchID,
      CreditDays,
      CreditLimit) async {
    final url = Uri.parse(
        '$APIGATEWAYBASEURL${TranactionType == "Vendor" ? '/insertvendor' : '/insertcustomerac'}');
    Map<String, dynamic> body = {
      "Name": Name,
      "Address": Address,
      "PhoneNumber": PhoneNumber,
      "EmailID": EmailID,
      "ContactPerson": ContactPerson,
      "GstNumber": GstNumber,
      "PanNumber": PanNumber,
      "TenantID": TenantID,
      "WorkspaceID": WorkspaceID,
      "BranchID": BranchID,
      "CreditDays": CreditDays,
      "CreditLimit": CreditLimit
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in insertvendor");
    }
  }

  static Future<List<SettingsModel>> loadSettings() async {
    try {
      var url = Uri.parse('$APIGATEWAYBASEURL/settings');
      var response = await http.get(url);
      print("check forceupdate");
      if (response.statusCode >= 400) {
        throw http.ClientException(response.body);
      }
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((e) => SettingsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      print("loadSettings:" + e.toString());
      rethrow;
    }
  }

  static Future<bool> insertproduct(
    Name,
    HSN,
    ProductType,
    Model,
    Brand,
    ProductCategory,
    TenantID,
    WorkspaceID,
    BranchID,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/insertproduct');
    Map<String, dynamic> body = {
      "Name": Name,
      "HSN": HSN,
      "ProductType": ProductType,
      "Model": Model,
      "Brand": Brand,
      "ProductCategory": ProductCategory,
      "TenantID": TenantID,
      "WorkspaceID": WorkspaceID,
      "BranchID": BranchID,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in insertvendor");
    }
  }

  static Future<bool> insertstock(
    body,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/insertstock');
    // List<Map<String,dynamic>> body
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in insertstock");
    }
  }

  static Future<List<ProductmasterModel>> getproducts(
      Tenantid, Workspacrid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/productmaster');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspacrid,
      "BranchID": branchid
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => ProductmasterModel.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in ProductmasterModel");
    } catch (e) {
      print(e);
      throw Exception("Error in ProductmasterModel");
    }
  }

  static Future<List<InvoiceReports>> getreports(
      Tenantid, Workspaceid, branchid, fromdate, todate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/reports');
    Map<String, dynamic> body = {
      "TenantID": Tenantid,
      "WorkspaceID": Workspaceid,
      "BranchID": branchid,
      "fromdate": fromdate,
      "todate": todate,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => InvoiceReports.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in Stock");
    } catch (e) {
      print(e);
      throw Exception("Error in Stock");
    }
  }

  static Future<String> forgotpassword(
    emailid,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/user/fgpwdemail');
    Map<String, dynamic> body = {"emailid": emailid};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return "Success, Password reset link sent to Email.\nPlease check your Inbox/spam for password reset link.";
      } else if (response.body.contains("User not found")) {
        return "Failed, User not found";
      }
      return "Failed";
    } catch (e) {
      print(e);

      throw Exception("Error in forgotpassword mail");
    }
  }

  static Future<List<EmployeeModel>> userfetchemployees(TenantID) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/nouseremployee');
    Map<String, dynamic> body = {"TenantID": TenantID};
    try {
      var response = await http.post(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map(
              (e) => EmployeeModel.fromjson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return Future.error("Error in fetchemployees");
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<List<EmployeeModel>> fetchusermgmt(TenantID) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/fetchusermanagement');
    Map<String, dynamic> body = {"TenantID": TenantID};
    try {
      var response = await http.post(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map(
              (e) => EmployeeModel.fromjson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return Future.error("Error in fetchemployees");
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<List<EmployeeModel>> fetchemployee(TenantID) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/employeedetails');
    Map<String, dynamic> body = {"TenantID": TenantID};
    try {
      var response = await http.post(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map(
              (e) => EmployeeModel.fromjson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return Future.error("Error in fetchemployees");
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<bool> deleteemployee(ID) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/employeedetails');
    Map<String, dynamic> body = {"ID": ID};
    try {
      var response = await http.delete(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        print("Success");
        // final List<dynamic> jsonData = jsonDecode(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<bool> insertemployee(
    Bytesdata,
    filetype,
    TenantID,
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
    EndDate,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/insertemployee');
    Map<String, dynamic> body = {
      "CSVBytes": Bytesdata,
      "filetype": filetype,
      "TenantID": TenantID,
      "EmployeeID": EmployeeID,
      "FirstName": FirstName,
      "MiddleName": MiddleName,
      "LastName": LastName,
      "PhoneNumber": PhoneNumber,
      "EmailID": EmailID,
      "Gender": Gender,
      "EmployeeType": EmployeeType,
      "Status": Status,
      "StartDate": StartDate,
      "EndDate": EndDate,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        print("Success");
        // final List<dynamic> jsonData = jsonDecode(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<bool> updatemeployee(
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
      EndDate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/employeedetails');
    Map<String, dynamic> body = {
      "ID": ID,
      "EmployeeID": EmployeeID,
      "FirstName": FirstName,
      "MiddleName": MiddleName,
      "LastName": LastName,
      "PhoneNumber": PhoneNumber,
      "EmailID": EmailID,
      "Gender": Gender,
      "EmployeeType": EmployeeType,
      "Status": Status,
      "StartDate": StartDate,
      "EndDate": EndDate
    };
    try {
      var response = await http.patch(url, body: json.encode(body));
      // final String response =
      //     await rootBundle.loadString('assets/images/employee.json');

      if (response.statusCode == 200) {
        print("Success");
        // final List<dynamic> jsonData = jsonDecode(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in fetch employees");
    }
  }

  static Future<bool> usermanagementaction(
    Create,
    Delete,
    UserID,
    UpdateJson,
    EmailID,
    TenantID,
    UserRole,
    PhoneNumber,
    FirstName,
    LastName,
    ID,
  ) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/usermanagementaction');
    Map<String, dynamic> body = {
      "Create": Create,
      "Delete": Delete,
      "UserID": UserID,
      "data": UpdateJson,
      "EmailID": EmailID,
      "TenantID": TenantID,
      "UserRole": UserRole,
      "PhoneNumber": PhoneNumber,
      "FirstName": FirstName,
      "LastName": LastName,
      "ID": ID
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        print("Success");
        return true;
      }
      return false;
    } catch (e) {
      print(e);

      throw Exception("Error in usermanagementaction");
    }
  }

  static Future<List<BankMaster>> bankmaster() async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankdetailshandler');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => BankMaster.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in bankmaster");
    } catch (e) {
      print(e);
      throw Exception("Error in bankmaster");
    }
  }

  static Future<List<IFSCBranches>> bankifsc(BankID) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankdetailshandler');
    Map<String, dynamic> body = {"bank_id": BankID};
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => IFSCBranches.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in bankifsc");
    } catch (e) {
      print(e);
      throw Exception("Error in bankifsc");
    }
  }

  static Future<List<IFSCBranches>> ifscdetails(ifscid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankdetailshandler');
    Map<String, dynamic> body = {"ifsc_id": ifscid};
    try {
      var response = await http.patch(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => IFSCBranches.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in ifscdetails");
    } catch (e) {
      print(e);
      throw Exception("Error in ifscdetails");
    }
  }

  static Future<List<BankAccounts>> bankaccounts(
      Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankaccountshandler');
    Map<String, dynamic> body = {
      "tenant_id": Tenantid,
      "workspace_id": Workspaceid,
      "branch_id": branchid,
    };
    try {
      var response = await http.put(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => BankAccounts.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in bankaccounts");
    } catch (e) {
      print(e);
      throw Exception("Error in bankaccounts");
    }
  }

  static Future<List<BankTransactions>> banktransactions(
      Tenantid, Workspaceid, branchid, bankid, ifscid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/transactionshandler');
    Map<String, dynamic> body = {
      "tenant_id": Tenantid,
      "workspace_id": Workspaceid,
      "branch_id": branchid,
      "bank_id": bankid,
      "ifsc_id": ifscid
    };
    try {
      var response = await http.put(url, body: json.encode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((e) => BankTransactions.fromjson(e as Map<String, dynamic>))
            .toList();
      }
      return Future.error("Error in banktransactions");
    } catch (e) {
      print(e);
      throw Exception("Error in banktransactions");
    }
  }

  static Future<bool> insertbank(bank_id, ifsc_id, account_holder_name,
      account_number, account_type, Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankaccountshandler');
    Map<String, dynamic> body = {
      "bank_id": bank_id,
      "ifsc_id": ifsc_id,
      "account_holder_name": account_holder_name,
      "account_number": account_number,
      "tenant_id": Tenantid,
      "workspace_id": Workspaceid,
      "branch_id": branchid,
      "account_type": account_type
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> inserttransaction(bank_id, ifsc_id, account_holder_name,
      account_number, account_type, Tenantid, Workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/bankaccountshandler');
    Map<String, dynamic> body = {
      "bank_id": bank_id,
      "ifsc_id": ifsc_id,
      "account_holder_name": account_holder_name,
      "account_number": account_number,
      "tenant_id": Tenantid,
      "workspace_id": Workspaceid,
      "branch_id": branchid,
      "account_type": account_type
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<GstMainmodel> salegst(
      tenantid, workspaceid, branchid, startdate, enddate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/gstreport');

    Map<String, dynamic> body = {
      "tenantid": tenantid,
      "workspaceid": workspaceid,
      "branchid": branchid,
      "fromdate": startdate,
      "enddate": enddate,
      "email": "no",
      "template": "template1"
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData["data"].isNotEmpty) {
          return GstMainmodel.fromjson(jsonData["data"]);
        } else {
          print("No Gst Data Found");
        }
      }
      return Future.error("Error in salegst");
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  salegst");
    }
  }

  static Future<bool> gstexport(
      tenantid, workspaceid, branchid, startdate, enddate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/gstreport');

    Map<String, dynamic> body = {
      "tenantid": tenantid,
      "workspaceid": workspaceid,
      "branchid": branchid,
      "fromdate": startdate,
      "enddate": enddate,
      "email": "yes",
      "template": ""
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  gstexport");
    }
  }

  static Future<List<Payable>> payable(tenantid, workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/payables');

    Map<String, dynamic> body = {
      "TenantID": tenantid,
      "WorkspaceID": workspaceid,
      "BranchID": branchid,
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map(
              (e) => Payable.fromjson(e),
            )
            .toList();
      }
      return Future.error("Error in payable");
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  payable");
    }
  }

  static Future<List<Receivable>> receivable(
      tenantid, workspaceid, branchid) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/receivables');

    Map<String, dynamic> body = {
      "TenantID": tenantid,
      "WorkspaceID": workspaceid,
      "BranchID": branchid,
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map(
              (e) => Receivable.fromjson(e),
            )
            .toList();
      }
      return Future.error("Error in receivable");
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  receivable");
    }
  }

  static Future<List<Purchase>> purchase(
      tenantid, workspaceid, branchid, startdate, enddate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/purchases');

    Map<String, dynamic> body = {
      "TenantID": tenantid,
      "WorkspaceID": workspaceid,
      "BranchID": branchid,
      "fromdate": startdate,
      "todate": enddate,
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map(
              (e) => Purchase.fromjson(e),
            )
            .toList();
      }
      return Future.error("Error in purchase");
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  purchase");
    }
  }

  static Future<List<Sale>> sale(
      tenantid, workspaceid, branchid, startdate, enddate) async {
    final url = Uri.parse('$APIGATEWAYBASEURL/sales');

    Map<String, dynamic> body = {
      "TenantID": tenantid,
      "WorkspaceID": workspaceid,
      "BranchID": branchid,
      "fromdate": startdate,
      "todate": enddate,
    };
    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map(
              (e) => Sale.fromjson(e),
            )
            .toList();
      }
      return Future.error("Error in Sale");
    } catch (e) {
      print(e.toString());
      throw Exception("Error in  Sale");
    }
  }
}
