// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shride/Model/UserProfile.dart';

class DatabaseService {
  final String uid;
  DatabaseService({ required this.uid});


  final CollectionReference userProfile = Firestore.instance.collection('userProfile');
  final CollectionReference trips = Firestore.instance.collection('trps');
  final CollectionReference requests = Firestore.instance.collection('requests');

  Future updateProfile(String firstName,String lastName, String mobile, String gender,String uid) async{
    userProfile.document(uid).setData({
      'firstName' : firstName,
      'lastName' : lastName,
      'mobile' : mobile,
      'gender' : gender,
      'uid' : uid
    });
  }



  Stream<QuerySnapshot> get profile{
    return userProfile.snapshots();
  }

  //trips
  Future addNewTrip(String source,double srcLatitude,double srcLongitude, String destination,double destLatitude, double destLongitude, String status, bool regular,String exception, String uid) async{
      String id = DateTime.now().toString();
      print(id);
      trips.document(id).setData({
        'source' : source,
        'destination' : destination,
        'id' : id,
        'status' : status,
        'regular' : regular,
        'exception' : exception,
        'srcLatitude' : srcLatitude,
        'srcLongitude' : srcLongitude,
        'destLatitude' : destLatitude,
        'destLongitude' : destLongitude,
        'uid' : uid,
      });
  }

  Future addNewRequest(String riderId, String passengerId,String riderName, String passengerName, String riderNumber, String passengerNumber,String pickUp, String dropOff, String status) async {
    requests.document().setData({
      'riderId' : riderId,
      'passengerId' : passengerId,
      'riderName' : riderName,
      'passengerName' : passengerName,
      'riderNumber' : riderNumber,
      'passengerNumber' : passengerNumber,
      'status' : status,
      'pickUp' : pickUp,
      'dropOff' : dropOff
    });
  }


}