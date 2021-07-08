//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shride/screens/login.dart';
import 'package:shride/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shride/Services/AuthService.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {


    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
            home: Wrapper(),

      ),
    );
  }
}
