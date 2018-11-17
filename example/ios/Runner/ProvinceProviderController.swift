//
//  ProvinceProviderController.swift
//  Runner
//
//  Created by sk on 2018/11/17.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import UIKit

class ProvinceProviderController: UIViewController {
     var channel:FlutterMethodChannel?
    var province: Dictionary<String, Any>?
    var arguments: Any?
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
       
        do{
            let bundle = Bundle.main.path(forResource: "province", ofType: "json")
//            let jsonFile = try String.init(contentsOfFile: bundle!)
//        province = try  JSONSerialization.jsonObject(with: jsonFile.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            if let arguments = self.arguments {
                self.titleView.text = "\(arguments)"
            }else{
                self.titleView.isHidden = true
            }

            self.pickerView.dataSource = self
            self.pickerView.delegate = self
            self.pickerView.reloadAllComponents()
        }catch{

print(error)
        }
    }
    override func loadView() {
        self.view = Bundle.main.loadNibNamed("ProvinceProviderController", owner: self, options: nil)?.first as! UIView
    }
    @IBAction func provicerCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func providerConfirmAction(_ sender: Any) {
       let provinceSelectedIndex = self.pickerView.selectedRow(inComponent: 0)
        let citySelectedIndex = self.pickerView.selectedRow(inComponent: 1)
        let schoolSelectedIndex = self.pickerView.selectedRow(inComponent: 2)
        
        if let channel = self.channel {
            
            let value =    ["type":"province","value":["province":"AAA","city":"BBB","school":"CCC"]] as [String : Any]
            channel.invokeMethod("provinceResult", arguments: value)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension ProvinceProviderController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "1"
        }else if component == 1{
            return "2"
        }else{
            return "3"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
}
extension ProvinceProviderController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}
