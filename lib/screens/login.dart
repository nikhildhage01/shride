
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shride/screens/register.dart';
import 'package:shride/Services/AuthService.dart';
/*
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);*/

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Color primaryGreen = Colors.lightBlueAccent;
  AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email ='';
  String pass = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        //backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Shride',
          style: TextStyle(
            fontFamily: 'NotoSansJP',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.cyan.shade500,
                Colors.greenAccent.shade100,
              ],
            )
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 143.0),
              TextFormField(
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w800,
                ),
                decoration: new InputDecoration(
                  labelText: 'Username',

                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);

                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: TextStyle(

                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w800,
                ),
                decoration: new InputDecoration(
                  labelText: 'Password',
                ),

                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a strong password' : null,
                onChanged: (val) {
                  setState(() => pass = val);
                },
              ),
              SizedBox(height: 50.0),
              RaisedButton(

                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                      dynamic result = _authService.loginWithEmailAndPass(email,pass);
                      if(result == null){
                        print('error');
                  }
                  }
                },
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text('Login',


                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'NotoSansJP',
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: InkWell(
                  child: Text('New User? Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'NotoSansJP',
                    ),
                  ),
                  onTap:() {Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register(),)
                  );},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
