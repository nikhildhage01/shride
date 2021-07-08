import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shride/Services/database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:shride/Model/UserProfile.dart';
import 'package:shride/Services/database.dart';
import 'package:shride/screens/Home/mainDrawer.dart';
String userId = '';
class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobile = TextEditingController();
  final gender = TextEditingController();

  UserProfile  userProfile = UserProfile(firstName: '', lastName: '', mobile: '', gender: '', uid: '');

  void initState(){
      super.initState();
      getUserData();
  }
  Future<void> getUserData() async {
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    setState(() {
      final String u = usr.uid;
      getData(u);
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService(uid: '').profile,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Profile',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'NotoSansJP',
          ),
          ),
        ),
        drawer: MainDrawer(),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
            /*decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.cyan.shade500,
                    Colors.greenAccent.shade100,
                  ],
                )
            ),*/
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 143.0),
                  TextFormField(
                    controller: firstName,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: new InputDecoration(
                      labelText: 'First Name',

                    ),
                    //validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                   // onChanged: (val) {
                     // setState(() => firstName = val);

                    //},
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: lastName,
                    style: TextStyle(
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: new InputDecoration(
                      labelText: 'Last Name',
                    ),

                  //  validator: (val) => val!.length == 10 ? 'Enter a 10 digit moblie number' : null,
                   // onChanged: (val) {
                     // setState(() => lastName = val);
                    //},
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: new InputDecoration(
                      labelText: 'Mobile Number ',

                    ),
                    // ignore: unrelated_type_equality_checks
                    validator: (val) => val!.isEmpty == 10 ? 'Enter a valid mobile number' : null,
                    //onChanged: (val) {
                    //  setState(() => mobile = val);

                    //},
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: gender,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: new InputDecoration(
                      labelText: 'Gender',

                    ),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                   // onChanged: (val) {
                    //  setState(() => gender = val);

                   // },
                  ),
                  SizedBox(height: 50.0),
                  // ignore: deprecated_member_use
                  RaisedButton(

                    onPressed: () async{
                        update(firstName.text, lastName.text, mobile.text, gender.text,);
                    },
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('Update',


                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NotoSansJP',
                        fontSize: 20,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future update(String first, String last, String m, String g) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    setState(() {
      String uid = firebaseUser.uid;
      print(userProfile.uid);
    });
    await DatabaseService(uid: firebaseUser.uid).updateProfile(first, last, m, g,userProfile.uid);
  }
  Future getData(String uid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usr = await auth.currentUser();
    firstName.text = '';
    lastName.text = '';
    mobile.text = '';
    gender.text = '';
    var result = await Firestore.instance.collection('userProfile').where('uid', isEqualTo: uid).getDocuments();
    result.documents.forEach((doc) {
      if(doc.exists){
          userProfile = UserProfile.fromDocument(doc);
          firstName.text = userProfile.firstName;
          lastName.text = userProfile.lastName;
          gender.text = userProfile.gender;
          mobile.text = userProfile.mobile;
      }
    });
  }



}
