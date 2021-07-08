// @dart = 2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shride/Handler/appData.dart';
import 'package:shride/MapServices/requestService.dart';
import 'package:shride/MapServices/serviceMethods.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:shride/screens/Home/newTrip.dart';
import 'package:shride/screens/Home/setRoute.dart';
import 'mainDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Rider extends StatefulWidget {


  @override
  _RiderState createState() => _RiderState();
}

class _RiderState extends State<Rider> {

  final _source = TextEditingController();
  final _destination = TextEditingController();
  GoogleMapController _googleMapController;
  Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Position _currentPosition;
  var geoLocator = Geolocator();
  AddressModel pickUp,dropOff;
  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};

  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentPosition = position;
    
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLng, zoom: 15);
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));



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
      body: (
        Stack(
          children: [
            GoogleMap(
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: true,
                polylines: polylineSet,
                onMapCreated: (GoogleMapController controller){
                  _mapController.complete(controller);
                  _googleMapController = controller;
                  locatePosition();
                }
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7,0.7)

                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        TextFormField(
                          onTap: () async {
                            pickUp = await  Navigator.push(context, MaterialPageRoute(builder: (context) => SetRoute()));
                            setState(() {
                              _source.text = pickUp.placeFormattedAdress;
                            });
                          },
                          controller: _source,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: new InputDecoration(
                            labelText: 'From where?',

                          ),
                          validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        ),
                        SizedBox(height: 15,),
                        
                        TextFormField(
                          controller: _destination,
                          onTap: () async {
                            dropOff = await  Navigator.push(context, MaterialPageRoute(builder: (context) => SetRoute()));
                            setState(() {
                              _destination.text = dropOff.placeFormattedAdress;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: new InputDecoration(
                            labelText: 'Where to ?',

                          ),
                          validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        ),
                        SizedBox(height: 15,),
                        RaisedButton(

                          onPressed: () {
                            print(pickUp.placeName);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewTrip(pickUp: pickUp,dropOff: dropOff,)));

                            },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('Go',


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
                )

            ),
          ],
        )
      ),
    );
  }

  Future<void> getRoute(AddressModel pickUp, AddressModel dropOff) async{

      var pickUpLocation = LatLng(pickUp.latitude , pickUp.longitude );
      var dropOffLocation = LatLng(dropOff.latitude , dropOff.longitude );

      var details = await ServiceMethods.obtainDirection(pickUpLocation, dropOffLocation);
      
      print(details.encodedPoints);

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(details.encodedPoints);

      plineCoordinates.clear();
      if(decodedPoints.isNotEmpty){
        decodedPoints.forEach((PointLatLng pointLatLng) {
            plineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
            print(pointLatLng.latitude);
        });
      }

      polylineSet.clear();

      setState(() {
        Polyline polyline = Polyline(
          color: Colors.green,
          polylineId: PolylineId('PolylineID'),
          jointType: JointType.round,
          points: plineCoordinates,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true
        );
        polylineSet.add(polyline);
      });

      LatLngBounds latLngBounds;
      if(pickUpLocation.latitude > dropOffLocation.latitude && pickUpLocation.latitude > dropOffLocation.latitude)
        latLngBounds = LatLngBounds(southwest: dropOffLocation, northeast: pickUpLocation);
      else if(pickUpLocation.longitude > dropOffLocation.longitude)
        latLngBounds = LatLngBounds(southwest: LatLng(pickUpLocation.latitude,dropOffLocation.longitude), northeast: LatLng(dropOffLocation.latitude,pickUpLocation.longitude));
      else if(pickUpLocation.latitude > dropOffLocation.latitude)
        latLngBounds = LatLngBounds(southwest: LatLng(dropOffLocation.latitude,pickUpLocation.longitude), northeast: LatLng(pickUpLocation.latitude,dropOffLocation.longitude));
      else
        latLngBounds = LatLngBounds(southwest: pickUpLocation, northeast: dropOffLocation);
      
      _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

  }

}
