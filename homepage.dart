// import 'package:crm_generatewealthapp/LoginSIgnup/usermodel.dart';
// import 'package:crm_generatewealthapp/common/contextextension.dart';
// import 'package:crm_generatewealthapp/common/shimmer.dart';
// import 'package:crm_generatewealthapp/contact/contactspage.dart';
// import 'package:crm_generatewealthapp/customer/customerpage.dart';
// import 'package:crm_generatewealthapp/leads/leadspage.dart';
// import 'package:crm_generatewealthapp/provider/Userprovider.dart';
// import 'package:crm_generatewealthapp/search/searchpage.dart';
// import 'package:crm_generatewealthapp/settingspage.dart';
// import 'package:crm_generatewealthapp/themeprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:provider/provider.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   UserModel? savedUser;
//   ValueNotifier<bool> isloading = ValueNotifier(false);
//   List? stackholdertypes;

//   @override
//   void initState() {
//     super.initState();
//   }

//   bool? ca;

//   Widget clc(currentTheme, issubagent, agentid, role, haveaccess, productid,
//       contactcount, leadscount, customercount) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: (contactcount == null || contactcount == '-')
//               ? SizedBox(
//                   height: 25,
//                   width: 25,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                   ))
//               : InkWell(
//                   onTap: () {
//                     {
//                       _userprovider.contactsdata();
//                     }
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Contactspage(
//                             access: haveaccess,
//                             productid: productid,
//                             agentid: agentid,
//                             role: role,
//                           ),
//                         ));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: currentTheme.primaryColorDark.withAlpha(50),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Contacts - ${contactcount}",
//                           style: currentTheme.textTheme.displayMedium
//                               ?.copyWith(color: currentTheme.primaryColorDark),
//                         ),
//                       )))),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: (leadscount == null || leadscount == '-')
//               ? SizedBox(
//                   height: 25,
//                   width: 25,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                   ))
//               : InkWell(
//                   onTap: () async {
//                     context.loaderOverlay.show();
//                     {
//                       await _userprovider.getleadstabs(_userprovider.selectedworkspace?.branchid);
//                       context.loaderOverlay.hide();
//                       _userprovider.leadsdata();
//                     }

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Leadspage(
//                             access: haveaccess,
//                             productid: productid,
//                             tabbarcount: _userprovider.leadstabs?.length,
//                             agentid: agentid,
//                             role: role,
//                           ),
//                         ));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: currentTheme.primaryColorDark.withAlpha(50),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Leads - ${leadscount}",
//                           style: currentTheme.textTheme.displayMedium
//                               ?.copyWith(color: currentTheme.primaryColorDark),
//                         ),
//                       )))),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: (customercount == null || customercount == '-')
//               ? SizedBox(
//                   height: 25,
//                   width: 25,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                   ))
//               : InkWell(
//                   onTap: () async {
//                     context.loaderOverlay.show();
//                     {
//                       await _userprovider.getcustomertabs(_userprovider.selectedworkspace?.branchid);
//                       context.loaderOverlay.hide();
//                       _userprovider.customersdata();
//                     }

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Customerpage(
//                             productid: productid,
//                             tabbarcount: _userprovider.customertabs?.length,
//                             agentid: agentid,
//                             role: role,
//                           ),
//                         ));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: currentTheme.primaryColorDark.withAlpha(50),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Customers - ${customercount}",
//                           style: currentTheme.textTheme.displayMedium
//                               ?.copyWith(color: currentTheme.primaryColorDark),
//                         ),
//                       )))),
//         )
//       ],
//     );
//   }

//   Widget cawidget(currentTheme, agentid, role, productid, customercount) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: (customercount == null || customercount == '-')
//           ? SizedBox(
//               height: 25,
//               width: 25,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//               ))
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: InkWell(
//                   onTap: () async {
//                     context.loaderOverlay.show();
//                     {
//                       await _userprovider.getcustomertabs(_userprovider.selectedworkspace?.branchid);
//                       context.loaderOverlay.hide();
//                       _userprovider.customersdata();
//                     }

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Customerpage(
//                             productid: productid,
//                             tabbarcount: _userprovider.customertabs?.length,
//                             agentid: agentid,
//                             role: role,
//                           ),
//                         ));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: currentTheme.primaryColorDark.withAlpha(50),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Customers - ${customercount}",
//                           style: currentTheme.textTheme.displayMedium
//                               ?.copyWith(color: currentTheme.primaryColorDark),
//                         ),
//                       )))),
//             ),
//     );
//   }

//   late Userprovider _userprovider;

//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     _userprovider = context.watchuser;
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     if (_userprovider.userdata?.tenantname == 'CA') {
//       ca = true;
//     } else {
//       ca = false;
//     }

//     return SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 "Welcome",
//                 style: TextStyle(color: currentTheme.canvasColor),
//               ),
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(20),
//               )),
//               backgroundColor: currentTheme.primaryColor,
//               automaticallyImplyLeading: false,
//               flexibleSpace: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Center(
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Center(
//                               child: Center(
//                                 child: IconButton(
//                                     color: currentTheme.canvasColor,
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Settingspage(),
//                                           ));
//                                     },
//                                     icon: const Icon(
//                                       Icons.settings,
//                                     )),
//                               ),
//                             ),
//                           ),
//                         ]),
//                   ),
//                 ],
//               ),
//             ),
//             body: SingleChildScrollView(
//                 child: Column(
//               children: [
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text("My Projects",
//                           style: currentTheme.textTheme.displayLarge)),
//                 ),
//                 ...?_userprovider.userdata?.productlist?.map((e) => Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: currentTheme.canvasColor,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: ExpansionTile(
//                           key: Key(index.toString()),
//                           initiallyExpanded: index ==
//                               _userprovider.userdata?.productlist?.indexOf(e),
//                           onExpansionChanged: (value) async {
//                             if (ca!) {
//                               if (value) {
//                                 setState(() {
//                                   index = _userprovider.userdata?.productlist
//                                           ?.indexOf(e) ??
//                                       0;
//                                 });
//                               }

//                               if (_userprovider.userdata?.role == 'Agent') {
//                                 await _userprovider.getagent(e['productid']);
//                               } else if (_userprovider.userdata?.role ==
//                                   'SuperUser') {
//                                 await _userprovider
//                                     .getsuperuser(e['productid']);
//                               }
//                               await _userprovider.getstackholdertypes(_userprovider.selectedworkspace?.branchid);
//                             } else {
//                               await _userprovider.getstackholdertypes(_userprovider.selectedworkspace?.branchid);
//                             }
//                             _userprovider.getcustomertabs(_userprovider.selectedworkspace?.branchid);
//                             _userprovider.getleadstabs(_userprovider.selectedworkspace?.branchid);
//                           },
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8),
//                                     child: SizedBox(
//                                       height: 50,
//                                       width: 45,
//                                       child: Image.asset(
//                                           "assets/images/${e["prodname"].toLowerCase().replaceAll(' ', '')}logo.png"),
//                                     ),
//                                   ),
//                                   Text(
//                                     e["prodname"] ?? '',
//                                     style: currentTheme.textTheme.displayLarge,
//                                   ),
//                                 ],
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   _userprovider.getallsearchdata();

//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => Searchpage(
//                                           productid: e['productid'],
//                                         ),
//                                       ));
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Container(
//                                         height: 30,
//                                         width: 110,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             border: Border.all(
//                                                 color:
//                                                     Colors.grey.withAlpha(127),
//                                                 width: 1.5)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10.0),
//                                           child: Center(
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 Icon(
//                                                   Icons.search,
//                                                   color: Colors.black87,
//                                                   size: 20,
//                                                 ),
//                                                 Text(
//                                                   'Search',
//                                                   style: currentTheme
//                                                       .textTheme.displaySmall,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Icon(Icons.keyboard_arrow_down_outlined,
//                                         color: currentTheme.primaryColor)
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                           showTrailingIcon: false,
//                           children: [
//                             if (_userprovider.userdata?.role == 'SubAgent') ...[
//                               if (!ca!) ...[
//                                 clc(
//                                   currentTheme,
//                                   true,
//                                   _userprovider.userdata?.agentid,
//                                   'SubAgent',
//                                   true,
//                                   e['productid'],
//                                   _userprovider.stakeholdertypes
//                                       ?.where((ed) => ed.name == "Contacts")
//                                       .toList()
//                                       .first
//                                       .count,
//                                   _userprovider.stakeholdertypes
//                                       ?.where((ed) => ed.name == "Leads")
//                                       .toList()
//                                       .first
//                                       .count,
//                                   _userprovider.stakeholdertypes
//                                       ?.where((ed) => ed.name == "Customers")
//                                       .toList()
//                                       .first
//                                       .count,
//                                 ),
//                               ] else ...[
//                                 cawidget(
//                                   currentTheme,
//                                   _userprovider.userdata?.agentid,
//                                   'SubAgent',
//                                   e['productid'],
//                                   _userprovider.stakeholdertypes
//                                       ?.where((ed) => ed.name == "Customers")
//                                       .toList()
//                                       .first
//                                       .count,
//                                 )
//                               ]
//                             ],
//                             if (_userprovider.userdata?.role == 'Agent') ...[
//                               _userprovider.getagents
//                                   ? Padding(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: ListTile(
//                                         leading: const ShimmerWidget.circular(
//                                             radius: 40),
//                                         title: ShimmerWidget.rectangular(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2.1,
//                                           height: 50,
//                                           shapeBorder: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                         ),
//                                         trailing:
//                                             Icon(Icons.keyboard_arrow_down),
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: ExpansionTile(
//                                         title: Row(
//                                           children: [
//                                             const Divider(
//                                               thickness: 3,
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: SizedBox(
//                                                 height: 35,
//                                                 child: Image.asset(
//                                                     "assets/images/heart.png"),
//                                               ),
//                                             ),
//                                             Text(
//                                               'Agent Self',
//                                               style: currentTheme
//                                                   .textTheme.displayLarge,
//                                             ),
//                                           ],
//                                         ),
//                                         children: [
//                                           if (!ca!) ...[
//                                             clc(
//                                               currentTheme,
//                                               false,
//                                               _userprovider.userdata?.agentid,
//                                               'Agent',
//                                               true,
//                                               e['productid'],
//                                               _userprovider.stakeholdertypes
//                                                   ?.where((ed) =>
//                                                       ed.name == "Contacts")
//                                                   .toList()
//                                                   .first
//                                                   .count,
//                                               _userprovider.stakeholdertypes
//                                                   ?.where((ed) =>
//                                                       ed.name == "Leads")
//                                                   .toList()
//                                                   .first
//                                                   .count,
//                                               _userprovider.stakeholdertypes
//                                                   ?.where((ed) =>
//                                                       ed.name == "Customers")
//                                                   .toList()
//                                                   .first
//                                                   .count,
//                                             ),
//                                           ] else ...[
//                                             cawidget(
//                                               currentTheme,
//                                               _userprovider.userdata?.agentid,
//                                               'Agent',
//                                               e['productid'],
//                                               _userprovider.stakeholdertypes
//                                                   ?.where((ed) =>
//                                                       ed.name == "Customers")
//                                                   .toList()
//                                                   .first
//                                                   .count,
//                                             )
//                                           ]
//                                         ],
//                                       ),
//                                     ),
//                               ...?_userprovider.agentdetails
//                                   ?.map((f) => _userprovider.getagents
//                                       ? Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 15),
//                                           child: ListTile(
//                                             leading: ShimmerWidget.circular(
//                                                 radius: 40),
//                                             title: ShimmerWidget.rectangular(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   2.1,
//                                               height: 50,
//                                               shapeBorder:
//                                                   RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15)),
//                                             ),
//                                             trailing:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                         )
//                                       : Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 15),
//                                           child: ExpansionTile(
//                                             title: Row(
//                                               children: [
//                                                 const Divider(
//                                                   thickness: 3,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8),
//                                                   child: SizedBox(
//                                                     height: 30,
//                                                     child: Image.asset(
//                                                         "assets/images/agent.png"),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   f.subagentname ?? '',
//                                                   style: currentTheme
//                                                       .textTheme.displayLarge,
//                                                 ),
//                                               ],
//                                             ),
//                                             children: [
//                                               if (!ca!) ...[
//                                                 clc(
//                                                   currentTheme,
//                                                   false,
//                                                   f.subagentid,
//                                                   'SubAgent',
//                                                   false,
//                                                   e['productid'],
//                                                   f.stakeholdertypecounts
//                                                       ?.where((e) {
//                                                     return e["name"] ==
//                                                         "Contacts";
//                                                   }).first["count"],
//                                                   f.stakeholdertypecounts
//                                                       ?.where((e) {
//                                                     return e["name"] == "Leads";
//                                                   }).first["count"],
//                                                   f.stakeholdertypecounts
//                                                       ?.where((e) {
//                                                     return e["name"] ==
//                                                         "Customers";
//                                                   }).first["count"],
//                                                 ),
//                                               ] else ...[
//                                                 cawidget(
//                                                   currentTheme,
//                                                   f.subagentid,
//                                                   'SubAgent',
//                                                   e['productid'],
//                                                   f.stakeholdertypecounts
//                                                       ?.where((e) {
//                                                     return e["name"] ==
//                                                         "Customers";
//                                                   }).first["count"],
//                                                 )
//                                               ]
//                                             ],
//                                           ),
//                                         )),
//                             ],
//                             if (_userprovider.userdata?.role ==
//                                 'SuperUser') ...[
//                               _userprovider.getsuperusers
//                                   ? Padding(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: ListTile(
//                                         leading:
//                                             ShimmerWidget.circular(radius: 40),
//                                         title: ShimmerWidget.rectangular(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2.1,
//                                           height: 50,
//                                           shapeBorder: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                         ),
//                                         trailing:
//                                             Icon(Icons.keyboard_arrow_down),
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: ExpansionTile(
//                                         title: Row(
//                                           children: [
//                                             const Divider(
//                                               thickness: 3,
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: SizedBox(
//                                                 height: 35,
//                                                 child: Image.asset(
//                                                     "assets/images/heart.png"),
//                                               ),
//                                             ),
//                                             Text(
//                                               'Super User',
//                                               style: currentTheme
//                                                   .textTheme.displayLarge,
//                                             ),
//                                           ],
//                                         ),
//                                         children: [
//                                           if (!ca!) ...[
//                                             clc(
//                                               currentTheme,
//                                               false,
//                                               _userprovider.userdata?.agentid,
//                                               'SuperUser',
//                                               true,
//                                               e['productid'],
//                                               _userprovider.stakeholdertypes ==
//                                                       null
//                                                   ? '-'
//                                                   : _userprovider
//                                                           .stakeholdertypes!
//                                                           .isEmpty
//                                                       ? '-'
//                                                       : _userprovider
//                                                           .stakeholdertypes
//                                                           ?.where((ed) =>
//                                                               ed.name ==
//                                                               "Contacts")
//                                                           .toList()
//                                                           .first
//                                                           .count,
//                                               _userprovider.stakeholdertypes ==
//                                                       null
//                                                   ? '-'
//                                                   : _userprovider
//                                                           .stakeholdertypes!
//                                                           .isEmpty
//                                                       ? '-'
//                                                       : _userprovider
//                                                           .stakeholdertypes
//                                                           ?.where((ed) =>
//                                                               ed.name ==
//                                                               "Leads")
//                                                           .toList()
//                                                           .first
//                                                           .count,
//                                               _userprovider.stakeholdertypes ==
//                                                       null
//                                                   ? '-'
//                                                   : _userprovider
//                                                           .stakeholdertypes!
//                                                           .isEmpty
//                                                       ? '-'
//                                                       : _userprovider
//                                                           .stakeholdertypes
//                                                           ?.where((ed) =>
//                                                               ed.name ==
//                                                               "Customers")
//                                                           .toList()
//                                                           .first
//                                                           .count,
//                                             ),
//                                           ] else ...[
//                                             cawidget(
//                                               currentTheme,
//                                               _userprovider.userdata?.agentid,
//                                               'SuperUser',
//                                               e['productid'],
//                                               _userprovider.stakeholdertypes ==
//                                                       null
//                                                   ? '-'
//                                                   : _userprovider
//                                                           .stakeholdertypes!
//                                                           .isEmpty
//                                                       ? '-'
//                                                       : _userprovider
//                                                           .stakeholdertypes
//                                                           ?.where((ed) =>
//                                                               ed.name ==
//                                                               "Customers")
//                                                           .toList()
//                                                           .first
//                                                           .count,
//                                             )
//                                           ]
//                                         ],
//                                       ),
//                                     ),
//                               ...?_userprovider.superuserdetails
//                                   ?.map((g) => _userprovider.getsuperusers
//                                       ? Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 15),
//                                           child: ListTile(
//                                             leading:
//                                                 const ShimmerWidget.circular(
//                                                     radius: 40),
//                                             title: ShimmerWidget.rectangular(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   2.1,
//                                               height: 50,
//                                               shapeBorder:
//                                                   RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15)),
//                                             ),
//                                             trailing:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                         )
//                                       : Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 15),
//                                           child: ExpansionTile(
//                                             title: Row(
//                                               children: [
//                                                 const Divider(
//                                                   thickness: 3,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8),
//                                                   child: SizedBox(
//                                                     height: 30,
//                                                     child: Image.asset(
//                                                         "assets/images/superuser.jpg"),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   g.agentname ?? '',
//                                                   style: currentTheme
//                                                       .textTheme.displayLarge,
//                                                 ),
//                                               ],
//                                             ),
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 15),
//                                                 child: ExpansionTile(
//                                                   title: Row(
//                                                     children: [
//                                                       const Divider(
//                                                         thickness: 3,
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8),
//                                                         child: SizedBox(
//                                                           height: 35,
//                                                           child: Image.asset(
//                                                               "assets/images/heart.png"),
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         '${g.agentname} Self',
//                                                         style: currentTheme
//                                                             .textTheme
//                                                             .displayLarge,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   children: [
//                                                     if (!ca!) ...[
//                                                       clc(
//                                                           currentTheme,
//                                                           false,
//                                                           g.agentid,
//                                                           'Agent',
//                                                           false,
//                                                           e['productid'],
//                                                           g.stakeholdertypecounts
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Contacts";
//                                                           }).first["count"],
//                                                           g.stakeholdertypecounts
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Leads";
//                                                           }).first["count"],
//                                                           g.stakeholdertypecounts
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Customers";
//                                                           }).first["count"]),
//                                                     ] else ...[
//                                                       cawidget(
//                                                           currentTheme,
//                                                           g.agentid,
//                                                           'Agent',
//                                                           e['productid'],
//                                                           g.stakeholdertypecounts
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Customers";
//                                                           }).first["count"])
//                                                     ]
//                                                   ],
//                                                 ),
//                                               ),
//                                               ...?g.subagents?.map(
//                                                 (h) => Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 15),
//                                                   child: ExpansionTile(
//                                                     title: Row(
//                                                       children: [
//                                                         const Divider(
//                                                           thickness: 3,
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(8),
//                                                           child: SizedBox(
//                                                             height: 30,
//                                                             child: Image.asset(
//                                                                 "assets/images/agent.png"),
//                                                           ),
//                                                         ),
//                                                         Text(
//                                                           h['subagentname'] ??
//                                                               '',
//                                                           style: currentTheme
//                                                               .textTheme
//                                                               .displayLarge,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     children: [
//                                                       if (!ca!) ...[
//                                                         clc(
//                                                           currentTheme,
//                                                           false,
//                                                           h['subagentid'],
//                                                           'SubAgent',
//                                                           false,
//                                                           e['productid'],
//                                                           h['stakeholdertypecounts']
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Contacts";
//                                                           }).first["count"],
//                                                           h['stakeholdertypecounts']
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Leads";
//                                                           }).first["count"],
//                                                           h['stakeholdertypecounts']
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Customers";
//                                                           }).first["count"],
//                                                         ),
//                                                       ] else ...[
//                                                         cawidget(
//                                                           currentTheme,
//                                                           h['subagentid'],
//                                                           'SubAgent',
//                                                           e['productid'],
//                                                           h['stakeholdertypecounts']
//                                                               ?.where((e) {
//                                                             return e["name"] ==
//                                                                 "Customers";
//                                                           }).first["count"],
//                                                         )
//                                                       ]
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         )),
//                             ]
//                           ],
//                         ),
//                       ),
//                     )),
//               ],
//             ))));
//   }
// }
