import 'dart:async';

import 'package:flutter/services.dart';


class ProvinceProvider {
  MethodChannel _channel ;

ProvinceProvider(){
  _channel =
  const MethodChannel('province_provider');
}

  ProvinceProvider provinceCallback(Future<dynamic> handler(MethodCall call)){
  _channel.setMethodCallHandler(handler);
  return this;
}
Future<dynamic> showProvinceProvider(String title   ) async{

 return   _channel.invokeMethod('showProvinceProvider',title);
}

   Future<LocationInfo> get locationInfo async{
    final Map locationInfo = await _channel.invokeMethod("getLocationInfo");

    return LocationInfo.fromMap(locationInfo);
  }

//  Future<Map<dynamic, dynamic>> showProvinceProvider() async{
//    final Map<dynamic, dynamic> result = await _channel.invokeMethod('showProvinceProvider',"HHH");
//    return result;
//  }



}
class Province{
  String name;
  List<City> city;
}
class City{
  String name;
  List<String> school;
}

class LocationInfo{
  String province;
  String city;
  String school;
  LocationInfo(this.province, this.city, this.school);
  LocationInfo.fromMap(Map<String, String> info){
    this.province =  info["province"];
    this.city = info["city"];
    this.school = info["school"];
  }
}
