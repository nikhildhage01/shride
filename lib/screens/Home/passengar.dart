// @dart = 2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shride/MapServices/requestService.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:shride/Model/predictionModel.dart';
import 'package:shride/Services/key.dart';
import 'package:shride/screens/Home/mainDrawer.dart';
import 'package:shride/screens/Home/searchRide.dart';
import 'package:shride/screens/Home/setRoute.dart';

class Passengar extends StatefulWidget {


  @override
  _PassengarState createState() => _PassengarState();
}

class _PassengarState extends State<Passengar> {

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
  AddressModel pickUp, dropOff;
  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentPosition = position;

    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(
        target: latLng, zoom: 15);
    _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
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
                  onMapCreated: (GoogleMapController controller) {
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 16.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7)

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
                              pickUp =
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SetRoute()));
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
                            validator: (val) =>
                            val.isEmpty
                                ? 'Enter an email'
                                : null,
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            controller: _destination,
                            onTap: () async {
                              dropOff =
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SetRoute()));
                              setState(() {
                                _destination.text =
                                    dropOff.placeFormattedAdress;
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
                            validator: (val) =>
                            val.isEmpty
                                ? 'Enter an email'
                                : null,
                          ),
                          SizedBox(height: 15,),
                          RaisedButton(

                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchRide(dropOff: dropOff,pickUp: pickUp,)));

                            },
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text('Search',


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

}
