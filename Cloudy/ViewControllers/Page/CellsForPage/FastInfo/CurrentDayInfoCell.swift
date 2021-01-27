//
//  CurrentDayInfoCell.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 20.01.2021.
//

import UIKit

class CurrentDayInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "CurrentDayInfoCell"
    
    static func nib() -> UINib {
    return UINib(nibName: "CurrentDayInfoCell", bundle: nil)
    }
    
    func configure(with current: CurrentDataWeatherbit, daily: weatherbitData) {
        infoLabel.text = "Today \n Temp: \(daily.max_temp)  \(daily.min_temp); feels like: \(daily.app_max_temp)  \(daily.app_min_temp). \n Wind: \(String(format: "%.2f",daily.wind_spd)) m/s, \(daily.wind_cdir_full). \n Precipitation: \(String(format: "%.2f", daily.precip)) mm \(Int(daily.rh))%"
        var style = "HelveticaNeue-Light"
        if UserDefaults.standard.bool(forKey: "style") == true {
            style = ".SFProText-Regular"
        }
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: style, size: 18)
    }
}
