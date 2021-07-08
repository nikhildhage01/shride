import 'package:flutter/material.dart';
import 'package:shride/screens/login.dart';
import 'package:shride/Services/AuthService.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color primaryGreen = Colors.lightBlueAccent;
  AuthService _auth = AuthService();
  String email = '';
  String pass = '';
  final _formKey = GlobalKey<FormState>();
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
                        dynamic result = await _auth.registerWithEmailAndPass(email,pass);
                        if(result == null){
                          print('Error');
                     }
                        else{
                     Navigator.push(context,
                     MaterialPageRoute(builder: (context) => Register(),)
                     );
                     }
                     }
                   },
                   color: Colors.blueAccent,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: Text('Register',
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
                    child: Text('Already Registered? Log In',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'NotoSansJP',
                      ),
                    ),
                    onTap:() {Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login(),)
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
