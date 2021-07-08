//@dart = 2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shride/Services/database.dart';

import 'mainDrawer.dart';
String uid = '';
class Requests extends StatefulWidget {
  const Requests({Key key}) : super(key: key);

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  DatabaseService databaseService;

  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    databaseService = DatabaseService(uid: uid);
  }

  getUid() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usr = await auth.currentUser();
    setState(() {
      uid = usr.uid;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Shride',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'NotoSansJP',
          ),
        ),
      ),
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('requests').where('passengerId', isEqualTo: uid).snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> docs = snapshot.data.documents;
              return ListView(
                  children: docs
                      .map((doc) => Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 30,bottom: 30),
                        child: Column(
                          children: [
                            Text(doc['riderName']),
                            SizedBox(height: 10,),
                            Text(doc['riderNumber']),
                            SizedBox(height: 10,),
                            Text('Status : '+doc['status']),
                            SizedBox(height: 30,),

                          ],
                        ),
                      )
                  ))
                      .toList());
            } else if (snapshot.hasError) {
              return Text('Its Error!');
            }
          }),
    );
  }
}
