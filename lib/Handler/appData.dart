
// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:shride/Model/addressModel.dart';

class AppData extends ChangeNotifier{

  AddressModel pickUpLocation;

  void updatePickUpLocation(AddressModel pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}