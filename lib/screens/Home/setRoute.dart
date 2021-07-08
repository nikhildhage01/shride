// @dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shride/Handler/appData.dart';
import 'package:shride/MapServices/requestService.dart';
import 'package:shride/MapServices/serviceMethods.dart';
import 'package:shride/Model/addressModel.dart';
import 'package:shride/Model/predictionModel.dart';
import 'package:shride/Services/key.dart';
import 'package:shride/screens/Home/mainDrawer.dart';

class SetRoute extends StatefulWidget {


  @override
  _SetRouteState createState() => _SetRouteState();
}

class _SetRouteState extends State<SetRoute> {

  final _source = TextEditingController();
  final _destination = TextEditingController();
  List<PredictionModel> predictionList = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitPosition();
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
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (val) {
                          findPlace(val);
                        },
                        controller: _source,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          labelText: 'From where?',
                          icon: Icon(Icons.pin_drop),

                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        onChanged: (val) {
                          findPlace(val);
                        },
                        controller: _destination,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          labelText: 'To where?',
                          icon: Icon(Icons.car_rental),

                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      ),
                    ],
                  ),
                ),
              ),
              (predictionList.length>0) ? 
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                      child: ListView.separated(
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context,index){
                          return PredictionTile(predictionModel: predictionList[index],);
                        },
                        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,),
                        itemCount: predictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                  )
                  : Container(),

            ],

          ),
        ),
      ),
    );
  }
  void findPlace(String placeName) async{
    if(placeName.length>1){
      String autoCompleteUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$apiKey&sessiontoken=1234567890&components=country:ind';
      var res = await RequestService.getRequest(autoCompleteUrl);

      // ignore: unrelated_type_equality_checks
      if(res == 'failed')
        return;
      print(res);
      if(res['status'] == 'OK'){
        var prediction = res['predictions'];
        var placeList = (prediction as List).map((e) => PredictionModel.fromJson(e)).toList();
        setState(() {
          predictionList = placeList;
        });
      }
    }
  }

  getInitPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _source.text = await ServiceMethods.searchCoordinateAddress(position);
  }
}

  Future getPlaceDetails(String placeId) async{

      String placeDetailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
      var res = await RequestService.getRequest(placeDetailsUrl);

      if(res == 'failed')
        return;

      if(res['status'] == 'OK'){
        AddressModel addressModel = AddressModel();
        addressModel.placeId = placeId;
        addressModel.placeName = res['result']['name'];
        addressModel.latitude = res['result']['geometry']['location']['lat'];
        addressModel.longitude = res['result']['geometry']['location']['lng'];
        addressModel.placeFormattedAdress = res['result']['formatted_address'];
        print(addressModel.latitude+addressModel.longitude);
        return addressModel;
      }

  }


class PredictionTile extends StatelessWidget {

  final PredictionModel predictionModel;
  const PredictionTile({Key key, this.predictionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () async{
          AddressModel addressModel = await getPlaceDetails(predictionModel.placeId);
          Navigator.pop(context,addressModel);

      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 12,),
            Row(
              children: [
                SizedBox(height: 10,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(predictionModel.label,

                          overflow: TextOverflow.ellipsis,
                          style: TextStyle( fontSize: 16),
                        ),
                        SizedBox(height: 3.0,),
                        Text(predictionModel.secondary, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),)
                      ],
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
