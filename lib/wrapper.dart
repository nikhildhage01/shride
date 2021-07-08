// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shride/Handler/appData.dart';
import 'package:shride/screens/Home/Home.dart';
import 'package:shride/screens/login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:shride/screens/Home/profile.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    // ignore: unnecessary_null_comparison
    if (user == null){
      return Login();
    } else
      return Home();
  }
}
