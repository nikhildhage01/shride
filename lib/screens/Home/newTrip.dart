// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:shride/screens/Home/Home.dart';
import 'package:shride/screens/Home/Post.dart';
import 'package:shride/screens/Home/mainDrawer.dart';
import 'package:shride/Services/database.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class NewTrip extends StatefulWidget {

  final AddressModel pickUp, dropOff;

  const NewTrip(
      {Key key, this.pickUp, this.dropOff})
      : super(key: key);
  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {

  DatabaseService databaseService;
  final _time = TextEditingController();
  final _id = TextEditingController();
  final _exception = TextEditingController();
  String _status = '';
  bool _regular = false;
  String uid;
  @override
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
      appBar:  AppBar(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Form(
                child: Column(
                  children: [
                      SizedBox(height: 20,),
                    Text('From',style: TextStyle(fontSize: 24),),
                    SizedBox(height: 20,),
                    Text(widget.pickUp.placeFormattedAdress, style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                    SizedBox(height: 20,),
                    Text('To',style: TextStyle(fontSize: 24),),
                    SizedBox(height: 20,),
                    Text(widget.dropOff.placeFormattedAdress,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    SizedBox(height: 20,),

                    SizedBox(height: 20,),
                    CheckboxListTile(
                      value: _regular,
                      onChanged: (val) {
                        setState(() {
                          _regular = val;
                        });

                      },
                      title: Text('Regular Ride'),
                    ),
                    SizedBox(height: 20,),
                    _regular ? TextFormField(
                      controller: _exception,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w800,

                      ),
                      decoration: new InputDecoration(
                        labelText: 'Exception',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                      ),
                    ) : TextFormField(enabled: false,),
                    SizedBox(height: 20,),

                    RaisedButton(

                      onPressed: () async{
                        databaseService.addNewTrip(widget.pickUp.placeFormattedAdress, widget.pickUp.latitude as double, widget.pickUp.longitude as double, widget.dropOff.placeFormattedAdress, widget.dropOff.latitude as double, widget.dropOff.longitude as double, 'Available', _regular, _exception.text,uid);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Posts()),(Route<dynamic> route) => false);

                      },
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Create Trip',


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
}


