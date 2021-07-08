import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
   final String firstName ;
   String lastName;
   String mobile;
   String gender;
   String uid;

  UserProfile({  required this.firstName, required this.lastName, required this.mobile, required this.gender, required this.uid});

   factory UserProfile.fromMap(Map data) {
     return UserProfile(
       firstName: data['firstName'],
       lastName: data['lastName'],
       mobile: data['mobile'],
       gender: data['gender'],
       uid: data['uid']
     );
   }
   factory UserProfile.fromDocument(DocumentSnapshot doc) {
     return UserProfile(
         firstName: doc['firstName'] ?? ' ',
         lastName: doc['lastName'] ?? ' ',
         gender: doc['gender'] ?? ' ',
         mobile: doc['mobile'] ?? ' ',
         uid: doc['uid'] ?? '',
     );
   }

   factory UserProfile.fromDS(String id, Map<String,dynamic> data) {
     return UserProfile(
       firstName: data['firstName'],
       lastName: data['lastName'],
       mobile: data['mobile'],
       gender: data['gender'],
       uid: data['uid']
     );
   }

   Map<String,dynamic> toMap() {
     return {
       "firstName":firstName,
       "lastName": lastName,
       "mobile":mobile,
       "gender":gender,
     };
   }


}
