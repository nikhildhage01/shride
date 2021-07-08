
// @dart = 2.9
class PredictionModel{
  String label;
  String secondary;
  String placeId;

  PredictionModel({ this.label,this.secondary, this.placeId});

  PredictionModel.fromJson(Map<String, dynamic> json){
    placeId = json['place_id'];
    label = json['structured_formatting']['main_text'];
    secondary = json['structured_formatting']['secondary_text'];
  }
}