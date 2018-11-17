import Flutter
import UIKit

public class SwiftProvinceProviderPlugin: NSObject, FlutterPlugin {
      var registrar: FlutterPluginRegistrar
    var channel:FlutterMethodChannel
    
    var provinceProvider:ProvinceProviderController =         ProvinceProviderController.init(nibName: "ProvinceProviderController", bundle: nil)

    
    //        provinceProvider.channel = channel
    
    init(registrar: FlutterPluginRegistrar, channel: FlutterMethodChannel) {
        self.registrar =  registrar
        self.channel = channel
        provinceProvider.channel = channel
    }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "province_provider", binaryMessenger: registrar.messenger())
    let instance = SwiftProvinceProviderPlugin(registrar: registrar, channel:channel)
    
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "showProvinceProvider" {
        self.provinceProvider.arguments = call.arguments
//        channel.invokeMethod("provinceResult", arguments: ["type":"province","value":["province":"AAA","city":"BBB","school":"CCC"]])
        self.provinceProvider.view.backgroundColor = UIColor.clear
        ( UIApplication.shared.delegate as! FlutterAppDelegate).window.rootViewController?.present(self.provinceProvider, animated: true, completion: {
            
        })
    }else{
        result("iOS " + UIDevice.current.systemVersion)
    }
    
   
  }
}
