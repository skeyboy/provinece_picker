import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:province_provider/province_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
    MethodChannel _channel =
  const MethodChannel('province_provider');
ProvinceProvider provinceProvider = new ProvinceProvider();
  @override
  void initState() {
    super.initState();

    provinceProvider.provinceCallback(_handler);


  }
  Future<dynamic> _handler(MethodCall methodCall){

    if(methodCall.method == "provinceResult"){
      Map<dynamic, dynamic> result = methodCall.arguments;
      var type = result["type"];
      if(type == "province"){
setState(() {
  Map<dynamic, dynamic> info = result["value"];
  _platformVersion = "$info";
});
      }
    }
    return Future.value(true);
  }
  LocationInfo locationInfo;

   // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
String platformVersion = "None";

final dynamic result = await provinceProvider.showProvinceProvider("选择籍贯");
setState(() {
  _platformVersion = "$locationInfo $result";
});
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:
        Column(children: <Widget>[
          RaisedButton(
            child: Text('Get Battery Level'),
            onPressed: initPlatformState,
          ),
          Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
        ],)

      ),
    );
  }
}
