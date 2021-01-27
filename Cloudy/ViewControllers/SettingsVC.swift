//
//  SettingsVC.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 26.01.2021.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var useFLabel: UILabel!
    @IBOutlet weak var useFSwitch: UISwitch!
    var isUseFahrenheit = UserDefaults.standard.bool(forKey: "units")
    
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleSwitch: UISwitch!
    var isStyleAmerican = UserDefaults.standard.bool(forKey: "style")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useFSwitch.isOn = isUseFahrenheit
        styleSwitch.isOn = isStyleAmerican
        styleLabel.font = UIFont(name: ".SFProText-Regular", size: 17)
    }
    
    @IBAction func useFahrenheitSwitch(_ sender: UISwitch) {
        if sender.isOn { isUseFahrenheit = true }
        else { isUseFahrenheit = false }
    }
    
    @IBAction func useAmericanStyleSwitch(_ sender: UISwitch) {
        if sender.isOn { isStyleAmerican = true }
        else { isStyleAmerican = false }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainFromSettingsVC" {
            UserDefaults.standard.removeObject(forKey: "units")
            UserDefaults.standard.set(isUseFahrenheit, forKey: "units")
            
            UserDefaults.standard.removeObject(forKey: "style")
            UserDefaults.standard.set(isStyleAmerican, forKey: "style")
        }
    }
    /*
     if value changed for useFSwitch {
     isUseFahrenheit = UserDefaults.standard.setValue(isUseFahrenheit, forKey: "units")
     }
     */
    
}
