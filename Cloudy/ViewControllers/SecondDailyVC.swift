//
//  FirstDayViewController.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 25.11.2020.
//

import UIKit

class SecondDailyViewController: UIViewController {
    
    //circle.fill
    
    
    var bit: weatherbitData!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var humLabel: UILabel!
    @IBOutlet var presLabel: UILabel!
    @IBOutlet var windDirectLabel: UILabel!
    @IBOutlet var cloudUVLabel: UILabel!
    @IBOutlet var precipLabel: UILabel!
    @IBOutlet var snowRainLabel: UILabel!
    @IBOutlet var sunriseSetLabel: UILabel!
    @IBOutlet var moonriseSetLabel: UILabel!
    
    func configure() {
        var style = "HelveticaNeue-Light"
        if UserDefaults.standard.bool(forKey: "style") == true {
            style = ".SFProText-Regular"
        }
        UserDefaults.standard.removeObject(forKey: "dailyData")
        dateLabel.text = "\(getDayForDate(Date(timeIntervalSince1970: Double(bit.ts))))"
        dateLabel.font = UIFont(name: style, size: 42)
        descriptionLabel.text  = "\(bit.weather.description)"
        descriptionLabel.font = UIFont(name: style, size: 23)
        
        tempLabel.text  = "\(Int(bit.max_temp))° \(Int(bit.min_temp))°"
        tempLabel.font = UIFont(name: style, size: 31)
        feelsLikeLabel.text  = "Feels like \(Int(bit.app_max_temp))° \(Int(bit.app_min_temp))°"
        feelsLikeLabel.font = UIFont(name: style, size: 18)
        windDirectLabel.text = "Wind speed \(NSString(format:"%.1f", bit.wind_spd)) m/s, direct \(bit.wind_cdir_full)."
        windDirectLabel.font = UIFont(name: style, size: 25)
        humLabel.text = "Humidity \(Int(bit.rh))%,"
        humLabel.font = UIFont(name: style, size: 26)
        presLabel.text = "pressure \(Int(bit.pres))mb."
        presLabel.font = UIFont(name: style, size: 26)
        
        cloudUVLabel.text = "Cloud coverage \(Int(bit.clouds))%, maximu UV index \(NSString(format:"%.1f", bit.uv)) \(getUVIndexTitle(with: Int(bit.uv)))"
        cloudUVLabel.font = UIFont(name: style, size: 24)
        
        snowRainLabel.text = "Snow \(NSString(format:"%.1f", bit.snow)) mm,                         Rain \(NSString(format:"%.1f", bit.precip)) mm"
        snowRainLabel.font = UIFont(name: style, size: 23)
        sunriseSetLabel.text = "Sunrise and sunset at     \(getHourForLabels(Date(timeIntervalSince1970: Double(bit.sunrise_ts)))) and \(getHourForLabels(Date(timeIntervalSince1970: Double(bit.sunset_ts))))."
        sunriseSetLabel.font = UIFont(name: style, size: 24)
        
        moonriseSetLabel.text = "Monrise and moonset at \(getHourForLabels(Date(timeIntervalSince1970: Double(bit.moonrise_ts)))) and \(getHourForLabels(Date(timeIntervalSince1970: Double(bit.moonset_ts)))), phase: \(getMoonPhase())"
        moonriseSetLabel.font = UIFont(name: style, size: 24)
    }
    
    func getUVIndexTitle(with UVValue: Int) -> String {
        var uv: String
        if UVValue >= 0 && UVValue < 3
        {uv = "Normal"}
        else if UVValue >= 3 && UVValue < 6
        {uv = "Moderate"}
        else if UVValue >= 6 && UVValue < 8
        {uv = "High"}
        else if UVValue >= 8 && UVValue < 11
        {uv = "Very-High"}
        else if UVValue >= 11
        {uv = "Extreme"}
        else {uv = "Khan!"}
        return uv
    }
   
    func getMoonPhase() -> String {
        var moonPhase: String
        if bit.moon_phase_lunation <= 1
        {moonPhase = "New moon"}
        else if bit.moon_phase_lunation >= 0.125 && bit.moon_phase_lunation <= 0.249
        {moonPhase = "Waxing Crescent"}
        else if bit.moon_phase_lunation >= 0.250 && bit.moon_phase_lunation <= 0.374
        {moonPhase = "First Quarter"}
        else if bit.moon_phase_lunation >= 0.375 && bit.moon_phase_lunation <= 0.499
        {moonPhase = "Wazing Qibbous"}
        else if bit.moon_phase_lunation >= 0.500 && bit.moon_phase_lunation <= 0.624
        {moonPhase = "Full Monn"}
        else if bit.moon_phase_lunation >= 0.625 && bit.moon_phase_lunation <= 0.749
        {moonPhase = "Wazning Gibbous"}
        else if bit.moon_phase_lunation >= 0.750 && bit.moon_phase_lunation <= 0.874
        {moonPhase = "Last Quarter"}
        else if bit.moon_phase_lunation >= 0.875 && bit.moon_phase_lunation <= 0.999
        {moonPhase = "Waning Crescent"}
        
        else {moonPhase = "\(bit.moon_phase_lunation)"}
        return moonPhase
    }
 
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd EEEE"
        return formatter.string(from: inputDate)
    }
    
    func getHourForLabels(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: inputDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = UIColor(red: 74/255, green: 142/255, blue: 202/255, alpha: 1.0)
    }
}

