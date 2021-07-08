

import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel{

  final String source;
  final String destination;
  final String id;
  final bool regular;
  final String exception;
  final double srcLatitude;
  final double srcLongitude;
  final double destLatitude;
  final double destLongitude;
  String status;

  TripModel({
    required this.source,
    required this.destination,
    required this.id,
    required this.regular,
    required this.exception,
    required this.status,
    required this.srcLatitude,
    required this.srcLongitude,
    required this.destLatitude,
    required this.destLongitude
});

  factory TripModel.fromDocument(DocumentSnapshot doc){
    return TripModel(
        source: doc['source'] ?? '',
        destination: doc['destination'] ?? '',
        id: doc['id'] ?? '',
        regular: doc['regular'] ?? '',
        exception: doc['exception'] ?? '',
        status: doc['status'] ?? '',
        srcLatitude: doc['srcLatitude'] ?? '',
        srcLongitude: doc['srcLongitude'] ?? '',
        destLatitude: doc['destLatitude'] ?? '',
        destLongitude: doc['destLongitude'] ?? '',
    );
  }

}