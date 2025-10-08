import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../LoginSIgnup/agentmodel.dart';
import '../LoginSIgnup/superusermodel.dart';
import '../LoginSIgnup/usermodel.dart';

class userdatastate {
  bool? isloadiing = false;
  List<UserModel>? userdetails;
  List<Agent>? agentdetails;
  List<Superuser>? superuserdetails;
  String? filter;
  userdatastate(
      {this.userdetails,
      this.agentdetails,
      this.superuserdetails,
      this.filter});

  userdatastate copyWith(
      {List<UserModel>? userdetails,
      List<Agent>? agentdetails,
      List<Superuser>? superuserdetail,
      bool? isloading,
      String? filter}) {
    return userdatastate(
      userdetails: userdetails ?? this.userdetails,
      agentdetails: agentdetails ?? this.agentdetails,
      filter: filter ?? this.filter,
      superuserdetails: superuserdetails ?? this.superuserdetails,
    );
  }
}

final userprovider = StateNotifierProvider<Userproviderriver, userdatastate>(
  (ref) => Userproviderriver(ref),
);

class Userproviderriver extends StateNotifier<userdatastate> {
  final Ref ref;
  Userproviderriver(this.ref)
      : super(userdatastate(
            userdetails: [],
            agentdetails: [],
            superuserdetails: [],
            filter: "All"));

  void filteruser(String filtername) {
    state = state.copyWith(isloading: true);
    List<UserModel>? userdetails =
        state.userdetails!.where((e) => e.email == filtername).toList();

    state = state.copyWith(userdetails: userdetails);
    state = state.copyWith(isloading: false);
  }
}
