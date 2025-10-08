// import 'package:crm_generatewealthapp/models/workspace_model.dart';

// class BranchFeature {
//   final String branchId;
//   final bool crmEnabled;
//   final bool accountingEnabled;

//   BranchFeature({
//     required this.branchId,
//     required this.crmEnabled,
//     required this.accountingEnabled,
//   });
// }

// class Branch {
//   final String branchId;
//   final List<String> features;

//   Branch({
//     required this.branchId,
//     required this.features,
//   });
// }

// class ChildCompany {
//   final String childCompanyId;
//   final List<Branch> branches;

//   ChildCompany({
//     required this.childCompanyId,
//     required this.branches,
//   });
// }

// class CompanyMenuData {
//   final String companyName;
//   final List<ChildCompany> childCompanies;

//   CompanyMenuData({
//     required this.companyName,
//     required this.childCompanies,
//   });
// }

// CompanyMenuData transformData(
//     List<WorkspaceModel> records, String companyName) {
//   final Map<String, Map<String, List<String>>> grouped = {};

//   for (final record in records) {
//     final childId = record.workspacename;
//     final branchId = record.branchname;

//     final features = record.featuresenabled;

//     grouped.putIfAbsent(childId!, () => {});
//     grouped[childId]!.putIfAbsent(branchId!, () => []);
//     grouped[childId]![branchId]!.addAll(features);
//   }

//   final childCompanies = grouped.entries.map((entry) {
//     final branches = entry.value.entries.map((branchEntry) {
//       return Branch(
//         branchId: branchEntry.key,
//         features: branchEntry.value.toSet().toList(), // unique features
//       );
//     }).toList();
//     return ChildCompany(
//       childCompanyId: entry.key,
//       branches: branches,
//     );
//   }).toList();

//   return CompanyMenuData(
//     companyName: companyName,
//     childCompanies: childCompanies,
//   );
// }
