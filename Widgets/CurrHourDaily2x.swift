//
//  CurrHourDaily2x.swift
//  WidgetsExtension
//
//  Created by Bogdan Grozyan on 27.11.2020.
//

import SwiftUI
import WidgetKit


struct CurrentHourlyDaily2xProvider: TimelineProvider {
    
    typealias Entry = ModelCurrentHourlyDaily2x
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingData = ModelCurrentHourlyDaily2x(date: Date(), response: WeatherResponseWeatherCurrentHourlyDaily2x(location: locationNameCurrentHourlyDaily2x(name: "Current"), current: currentDataWeatherAPICurrentHourlyDaily2x(temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), forecast: forecastWeatherResposeWeatherAPICurrentHourlyDaily2x(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPICurrentHourlyDaily2x(date_epoch: 01, day: Array(repeating: dailyDataWeatherAPICurrentHourlyDaily2x(maxtemp_c: 0, mintemp_c: 0, condition: dailyDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), count: 01), hour: Array(repeating: hourlyDataWeatherAPICurrentHourlyDaily2x(time_epoch: 0, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "0", chance_of_snow: "0", vis_km: 0, condition: hourlyDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), count: 24)), count: 1))))
        
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ModelCurrentHourlyDaily2x>) -> Void) {
        HourlyCurrHourDaily2xDataRequest { (modelData) in
            let date = Date()
            let data = ModelCurrentHourlyDaily2x(date: date, response: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30,to: date)
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> ModelCurrentHourlyDaily2x {
        let loadingData = ModelCurrentHourlyDaily2x(date: Date(), response: WeatherResponseWeatherCurrentHourlyDaily2x(location: locationNameCurrentHourlyDaily2x(name: "Current"), current: currentDataWeatherAPICurrentHourlyDaily2x(temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), forecast: forecastWeatherResposeWeatherAPICurrentHourlyDaily2x(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPICurrentHourlyDaily2x(date_epoch: 01, day: Array(repeating: dailyDataWeatherAPICurrentHourlyDaily2x(maxtemp_c: 0, mintemp_c: 0, condition: dailyDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), count: 01), hour: Array(repeating: hourlyDataWeatherAPICurrentHourlyDaily2x(time_epoch: 0, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "0", chance_of_snow: "0", vis_km: 0, condition: hourlyDataWeatherWeatherAPICurrentHourlyDaily2x(text: "Text", icon: "Icon")), count: 24)), count: 1))))
        
        
        return loadingData
    }
}


func HourlyCurrHourDaily2xDataRequest(completion: @escaping(WeatherResponseWeatherCurrentHourlyDaily2x) -> ()) {
    
    let url =  "http://api.weatherapi.com/v1/forecast.json?key=4bb04dd4c8974b94b23135236200511&q=44.7404,33.853576"
    
URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
    
    guard let data = data, error == nil else {
        print("somethingWentWrongWeatherAPI")
        return
    }
    
    if error == nil {
        print("WidgetWeatherAPI - Works")
    } else {
        print("WidgetWeatherAPI - Error")
    }

    var json: WeatherResponseWeatherCurrentHourlyDaily2x?
    do {
        json = try JSONDecoder().decode(WeatherResponseWeatherCurrentHourlyDaily2x.self, from: data)
        completion(json!)
    }
    catch {
        print("error: \(error)")
    }
    
    print("\(json!.location.name) WazapHourly")
}).resume()
}



struct ModelCurrentHourlyDaily2x: TimelineEntry {

   public var date: Date
    
   public var response: WeatherResponseWeatherCurrentHourlyDaily2x
}

struct WeatherResponseWeatherCurrentHourlyDaily2x: Codable {
    let location: locationNameCurrentHourlyDaily2x
    let current: currentDataWeatherAPICurrentHourlyDaily2x
    let forecast: forecastWeatherResposeWeatherAPICurrentHourlyDaily2x
}

struct locationNameCurrentHourlyDaily2x: Codable {
    let name: String
}

struct currentDataWeatherAPICurrentHourlyDaily2x: Codable {
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let vis_km: Float
    let condition: currentDataWeatherWeatherAPICurrentHourlyDaily2x
}

struct currentDataWeatherWeatherAPICurrentHourlyDaily2x: Codable {
    let text: String
    let icon: String
}

struct forecastWeatherResposeWeatherAPICurrentHourlyDaily2x: Codable {
    let forecastday: [forecastdayFor8DaysWeatherAPICurrentHourlyDaily2x]
}

struct forecastdayFor8DaysWeatherAPICurrentHourlyDaily2x: Codable {
    let date_epoch: Int
    let day: [dailyDataWeatherAPICurrentHourlyDaily2x]
    let hour: [hourlyDataWeatherAPICurrentHourlyDaily2x]
}

struct dailyDataWeatherAPICurrentHourlyDaily2x: Codable {
    let maxtemp_c: Float
    let mintemp_c: Float
    let condition: dailyDataWeatherWeatherAPICurrentHourlyDaily2x
}

struct dailyDataWeatherWeatherAPICurrentHourlyDaily2x: Codable {
    let text: String
    let icon: String
}


struct hourlyDataWeatherAPICurrentHourlyDaily2x: Codable {
    let time_epoch: Int
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let chance_of_rain: String
    let chance_of_snow: String
    let vis_km: Float
    let condition: hourlyDataWeatherWeatherAPICurrentHourlyDaily2x
}

struct hourlyDataWeatherWeatherAPICurrentHourlyDaily2x: Codable {
    let text: String
    let icon: String
}
