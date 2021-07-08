

// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shride/Handler/appData.dart';
import 'package:shride/MapServices/requestService.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:shride/Model/directionModel.dart';
import 'package:shride/Services/key.dart';
AddressModel userPickUpAddess = AddressModel();
class ServiceMethods{


  static Future<String> searchCoordinateAddress(Position position) async{
    String placeAddress = '';
    String url =  'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    var response = await RequestService.getRequest(url);

    if(response != 'failed'){
      placeAddress = response['results'][0]['formatted_address'];


      userPickUpAddess.longitude = position.longitude ;
      userPickUpAddess.latitude = position.latitude;
      userPickUpAddess.placeName = placeAddress;
    }
    return placeAddress;
  }

  static Future obtainDirection(LatLng source, LatLng destination) async{
    String directionUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    var res = await RequestService.getRequest(directionUrl);

    if(res == 'failed')
      return null;

    DirectionModel directionModel = DirectionModel();

    directionModel.encodedPoints = res['routes'][0]['overview_polyline']['points'];
    directionModel.distanceText = res['routes'][0]['legs'][0]['distance']['text'];
    directionModel.distanceValue = res['routes'][0]['legs'][0]['distance']['value'];
    directionModel.durationText = res['routes'][0]['legs'][0]['duration']['text'];
    directionModel.durationValue = res['routes'][0]['legs'][0]['duration']['value'];

    return directionModel;

  }
}