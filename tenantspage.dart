import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/landingpagenewalter.dart';
import 'package:crm_generatewealthapp/main.dart';
import 'package:crm_generatewealthapp/provider/Userprovider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TenantsPage extends StatefulWidget {
  const TenantsPage({super.key});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {
  late Userprovider _userprovider;

  gettenants() {
    return _userprovider.tenants.map((e) {
      return InkWell(
        onTap: () async {
          context.loaderOverlay.show();
          await _userprovider.setselectedtenant(e);
          context.loaderOverlay.hide();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Landingpagenewalter()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        Text(
                          e.tenantname ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          color: Colors.indigo[100],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon(
                              //   Icons.admin_panel_settings,
                              //   color: Colors.black54,
                              //   size: 18,
                              // ),
                              Text(
                                e.userrole ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate("app_Industry"),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          (e.industry ?? "Finance"),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("app_gst"),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          (e.gstnumber ?? "123456789012345"),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _userprovider = context.watchuser;
    return SingleChildScrollView(
        child: Center(
            child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: gettenants()),
    )));
  }
}
