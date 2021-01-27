//
//  DailyTableViewCell.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 20.11.2020.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let identifier = "DailyTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell",
                     bundle: nil)
    }
    var style = "HelveticaNeue-Light"
    func configure(with bit: weatherbitData) {
        if UserDefaults.standard.bool(forKey: "style") == true {
            style = ".SFProText-Regular"
        }
        minTempLabel.text = "\(Int(bit.min_temp))°"
        minTempLabel.font = UIFont(name: style, size: 22)
        minTempLabel.textColor = .white
        maxTempLabel.text = "\(Int(bit.max_temp))°"
        maxTempLabel.font = UIFont(name: style, size: 22)
        maxTempLabel.textColor = .white
        dateLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(bit.ts)))
        dateLabel.font = UIFont(name: style, size: 20)
        dateLabel.textColor = .white
        iconImage.tintColor = .white
        let icon = bit.weather.icon
        if icon == "t01d" || icon == "t01n" || icon == "t02d" || icon == "t02n" || icon == "t03d" || icon == "t03n" || icon == "t04d" || icon == "t04n" || icon == "t05d" || icon == "t05n"
        { iconImage.image = UIImage(named: "Thunder") }
        else if icon == "d01d" || icon == "d01n" || icon == "d02d" || icon == "d02n" || icon == "d03d"      || icon == "d03n" ||
            icon == "r01d" || icon == "r01n" || icon == "r02d" || icon == "r02n" || icon == "r03d" || icon == "r03n" || icon == "r04d" || icon == "r04n" || icon == "r05d" || icon == "r05n" || icon == "r06d" || icon == "r06n" || icon == "f01d" || icon == "f01n"
        { iconImage.image = UIImage(named: "Rain") }
        else if icon == "s01d" || icon == "s01n" || icon == "s02d" || icon == "s02n" || icon == "s03d" || icon == "s03n" || icon == "s04d" || icon == "s04n" || icon == "s05d" || icon == "s05n" || icon == "s06d" || icon == "s06n"
        { iconImage.image = UIImage(named: "Snow")}
        else if icon == "a01d" || icon == "a01n" || icon == "a02d" || icon == "a02n" || icon == "a03d" || icon == "a03n" || icon == "a04d" || icon == "a04n" || icon == "a05d" || icon == "a05n" || icon == "a06d" || icon == "a06n" || icon == "c04d" || icon == "a04n" || icon == "c03d" || icon == "a03n"
        { iconImage.image = UIImage(named: "Cloud") }
        else if icon == "c01d" { iconImage.image = UIImage(named: "Sun") }
        else if icon == "c01n" { iconImage.image = UIImage(named: "Moon") }
        else if icon == "c02d" || icon == "a03d" { iconImage.image = UIImage(named: "CloudSun") }
        else if icon == "c02n" || icon == "a03n" { iconImage.image = UIImage(named: "CloudMoon") }
        else { iconImage.image = UIImage(named: "CloudSun")}
        
        
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
    
}

