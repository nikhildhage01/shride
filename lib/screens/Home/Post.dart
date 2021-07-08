// @dart = 2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shride/Services/database.dart';

import 'mainDrawer.dart';
String uid = '';
class Posts extends StatefulWidget {
  const Posts({Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

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
          stream: Firestore.instance.collection('requests').where('riderId', isEqualTo: uid).snapshots(),
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
                          Text(doc['passengerName']),
                          SizedBox(height: 10,),
                          Text(doc['passengerNumber']),
                          SizedBox(height: 10,),
                          Text('Pick Up'),
                          SizedBox(height: 10,),
                          Text(doc['pickUp']),
                          SizedBox(height: 10,),
                          Text('Drop Off'),
                          SizedBox(height: 10,),
                          Text(doc['dropOff']),
                          SizedBox(height: 10,),
                          Text('Status : '+doc['status']),
                          SizedBox(height: 30,),


                          Padding(
                            padding: const EdgeInsets.only(left: 80),
                            child: Row(
                              children: [
                                FlatButton(
                                    onPressed: (){
                                      acceptRequest(doc.documentID);
                                    },
                                    color: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text('Accept')
                                ),
                                SizedBox(width: 10, height: 0,),
                                FlatButton(
                                    onPressed: (){
                                      rejectRequest(doc.documentID);
                                    },
                                    color: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text('Reject')
                                )
                              ],
                            ),

                          ),
                          FlatButton(
                              onPressed: (){
                                completeRide(doc.documentID);
                              },
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('Complete Ride')
                          )
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
  acceptRequest(String docId) async{
    await Firestore.instance.collection('requests').document(docId).updateData({'status' : 'Accepted'});
  }
  rejectRequest(String docId) async{
    await Firestore.instance.collection('requests').document(docId).updateData({'status' : 'Rejected'});
  }
  completeRide(String docId) async{
    Firestore.instance.collection('requests').document(docId).delete();
  }
}
