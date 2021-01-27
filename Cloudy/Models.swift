//
//  Models.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 04.12.2020.
//

import Foundation

struct LocationName: Decodable {
    let data: [cityData]
}

struct cityData: Decodable {
    let city_name: String
    //let country_full: String
}

struct locationParam: Codable {
    let name: String
    let lat: String
    let lon: String
}

//MARK: Current Weatherbit     !!!
//https://api.weatherbit.io/v2.0/current?lat=44.7404&lon=33.853576&key=5f210cde805d4ea782ff4e4c3fbbbfb9
struct CurrentResponseWeatherbit: Codable {
    let data: [CurrentDataWeatherbit]
}

struct CurrentDataWeatherbit: Codable {
    let lon: Double
    let lat: Double
    let city_name: String
    let ts: Int //
    let temp: Float
    let app_temp: Float //
    let rh: Float
    let pres: Float
    let wind_spd: Float
    let wind_cdir: String //
    //let clouds: String //
    let vis: Float
    let snow: Float //
    let uv: Float //
    let precip: Float
    let sunrise: String
    let sunset: String
    let weather: CurrentWeatherWeatherbit
}

struct CurrentWeatherWeatherbit: Codable {
    let description: String
    let icon: String //
}




//MARK: HourlyWeatherbit !!
//https://api.weatherbit.io/v2.0/forecast/hourly?lat=44.7404&lon=33.853576&key=5f210cde805d4ea782ff4e4c3fbbbfb9&hours=48
struct HourlyResponseWeatherbit: Codable {
    let data: [HourlyDataWeatherbit]
}

struct HourlyDataWeatherbit: Codable {
    let ts: Int
    let temp: Float
    let weather: HourlyWeatherWeatherbit
}

struct HourlyWeatherWeatherbit: Codable {
    let icon: String
    let description: String
}



//MARK: Daily Weatherbit
struct DailyWeatherbit: Codable {
    
    let data: [weatherbitData]
}

struct weatherbitData: Codable {
    let datetime: String
    let ts: Int
    
    let snow: Float
    let max_temp: Float
    let min_temp: Float
    let app_max_temp: Float //feelslike
    let app_min_temp: Float
    
    let pop: Float //% of prociptation
    let precip: Float //mm
    let rh: Float //%
    let pres: Float //mb
    let vis: Float
    let uv: Float
    
    let clouds: Float //% coverage
    let wind_cdir_full: String //wind direction
    let wind_spd: Float //ms
    
    let sunrise_ts: Int
    let sunset_ts: Int
    
    let moon_phase_lunation: Float // 0 = New moon, 0.50 = Full Moon, 0.75 = Last quarter moon
    let moonrise_ts: Int
    let moonset_ts: Int
    
    
    let weather: weatherbitWeather
}

struct weatherbitWeather: Codable {
    let icon: String
    let description: String
}





//MARK: Alert Weatherbit   !!!
/*
 Can't do without appleDeveloper enrole program
struct alertResponseWeatherbit: Codable {
    let effectrive_local: String //when notify will creating(for 3 hours before)
    let expires_local: String //when notify will disappear
    let onset_local: String //start of event
    let ends_local: String //end of event
    
    let alerts: [alertWeatherbit]
}

struct alertWeatherbit: Codable {
    let title: String
    let descripion: String
}


func getHourForDate(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h a"
    return formatter.string(from: inputDate)
}

func convertStringToTs(_ date: String) -> Double {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm"
    let dateString = formatter.date(from: date)
    let dateTimeStamp = dateString!.timeIntervalSince1970
    return dateTimeStamp
}


func getHourForStruct(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: inputDate)
}
*/

