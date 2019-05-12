//
//  SettingsViewController.swift
//  Timer1
//
//  Created by John Holland on 4/14/19.
//  Copyright © 2019 John Holland. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var settingHolder:SettingHolder = SettingHolder.shared
   
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let desiredTime = defaults.integer(forKey:"Time")
        settingHolder.desiredTime = desiredTime
        settingHolder.hour = desiredTime / (60*60)
        settingHolder.minutes = (desiredTime / 60) % 60
        settingHolder.seconds = desiredTime % 60
        
        picker.delegate = self;
        picker.dataSource = self;
        picker.selectRow(settingHolder.hour, inComponent: 0, animated: false)
        picker.selectRow(settingHolder.minutes, inComponent: 1, animated: false)
        picker.selectRow(settingHolder.seconds, inComponent: 2, animated: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        settingHolder.started = false
        settingHolder.paused  = false
        }
    
    @IBAction func setDefaultTime() {
        settingHolder.defaults.set(settingHolder.desiredTime, forKey:"Time")
        
        
    }
    @IBOutlet weak var picker: UIPickerView!
   
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hour"
        case 1:
            return "\(row) Minute"
        case 2:
            return "\(row) Second"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            settingHolder.hour = row
        case 1:
            settingHolder.minutes = row
        case 2:
            settingHolder.seconds = row
        default:
            break;
        }
    }
}
