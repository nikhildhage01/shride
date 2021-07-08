// @dart = 2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:shride/MapServices/serviceMethods.dart';
import 'package:shride/Model/UserProfile.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:extended_math/extended_math.dart';
import 'package:shride/Services/database.dart';
import 'package:shride/screens/Home/Home.dart';
String id = '';
String uid = '';
UserProfile riderProfile, passangerProfile;
class SearchRide extends StatefulWidget {
  final AddressModel dropOff,pickUp;
  const SearchRide({Key key, this.dropOff, this.pickUp}) : super(key: key);

  @override
  _SearchRideState createState() => _SearchRideState();
}

class _SearchRideState extends State<SearchRide> {

  List<LatLng> plineCoordinates = [];




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
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('trps').where('destination', isEqualTo: widget.dropOff.placeFormattedAdress).getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
           // ignore: missing_return
           return Text('No Data');
          final List<DocumentSnapshot> docs = snapshot.data.documents;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: FlatButton(
                      onPressed: () async {
                         id = await getRoute(widget.dropOff);
                         print(id);
                      },
                      child: Text('Tap'),
                    ),
                ),
                Container(
                    child: Ride(documentId: id, pickUp: widget.pickUp,dropOff: widget.dropOff,),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  getRoute(AddressModel dropOff) async{

    var res = await Firestore.instance.collection('trps').getDocuments();
    double lat = roundDouble(dropOff.latitude, 6);
    double lng = roundDouble(dropOff.longitude, 5);

     res.documents.forEach((doc) async {

      var pickUpLocation = LatLng(doc['srcLatitude'], doc['srcLongitude']);
      var dropOffLocation = LatLng(doc['destLatitude'], doc['destLongitude']);
      var details = await ServiceMethods.obtainDirection(pickUpLocation, dropOffLocation);

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(details.encodedPoints);


      if(decodedPoints.isNotEmpty){
        decodedPoints.forEach((PointLatLng pointLatLng) {
          // print(pointLatLng.latitude - lat);
          if((pointLatLng.latitude - lat >= -0.0003 && pointLatLng.latitude-lat <=0.0003) && (pointLatLng.longitude - lng >= -0.0003 && pointLatLng.longitude - lng <=0.0003)){
            // print('***********************************************************************');
            // print(doc.documentID);
            print(pointLatLng.latitude-lat);
            id = doc.documentID;
            print(id);
          }

        });

      }


    });
  }
  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

}


class Ride extends StatefulWidget {
  final String documentId;
  final AddressModel pickUp, dropOff;
  const Ride({Key key, this.documentId, this.pickUp, this.dropOff}) : super(key: key);

  @override
  _RideState createState() => _RideState();
}

class _RideState extends State<Ride> {
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
    CollectionReference reference = Firestore.instance.collection('trps');

    return FutureBuilder<DocumentSnapshot>(
        future: reference.document(widget.documentId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if(!snapshot.hasData)
            return Text('No Ride Available at this time');
          Map<String, dynamic> data = snapshot.data.data;
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text('To : '+data['destination']),
                  subtitle: Text('From : '+data['source']),
                ),
                FlatButton(
                    onPressed: () async{
                      String rid = data['uid'];
                      UserProfile r = await getRiderDetails(rid);

                      UserProfile p = await getPassengerDetails(uid);
                      print(p.firstName);

                      databaseService.addNewRequest(rid,uid,r.firstName,p.firstName,r.mobile,p.mobile,widget.pickUp.placeFormattedAdress,widget.dropOff.placeFormattedAdress,'pending');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text('Request')
                )
              ],
            ),
          );
        }
    );
  }

  getRiderDetails(String riderId) async{
    var result = await Firestore.instance.collection('userProfile').where('uid', isEqualTo: riderId).getDocuments();
    result.documents.forEach((doc) {
      if(doc.exists){
        riderProfile = UserProfile.fromDocument(doc);
      }
    });
    return riderProfile;
  }
  getPassengerDetails(String passengerId) async{
    var result = await Firestore.instance.collection('userProfile').where('uid', isEqualTo: passengerId).getDocuments();
    result.documents.forEach((doc) {
      if(doc.exists){
        passangerProfile = UserProfile.fromDocument(doc);
      }
    });

    return passangerProfile;
  }
}
