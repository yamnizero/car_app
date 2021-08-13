import 'package:car_app/Assistants/requestAssistant.dart';
import 'package:car_app/Screens/registerationScreen.dart';
import 'package:car_app/configMaps.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods
{
 static Future<String?> searchCoordinateAddress(Position position) async
 {
  String placeAddress= "";
  Uri url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");


  var response = await RequestAssistant.getRequest(url);

  if(response != "failed")
   {
    placeAddress = response["results"][0]["formatted_address"];
   }
  return placeAddress;
 }
}