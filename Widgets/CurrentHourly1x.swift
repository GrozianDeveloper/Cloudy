//
//  CurrentHourly1x.swift
//  WidgetsExtension
//
//  Created by Bogdan Grozyan on 26.11.2020.
//

import SwiftUI
import WidgetKit

struct CurrentHourly1xProvider: TimelineProvider {
    
    typealias Entry = ModelCurrentHourly1x
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingData = ModelCurrentHourly1x(date: Date(), response: WeatherResponseWeatherCurrentHourly1x(location: locationNameCurrentHourly1x(name: "Current"), current: currentDataWeatherAPICurrentHourly1x(temp_c: 0, wind_kph: 0, pressure_mb: 00, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPICurrentHourly1x(text: "Text", icon: "Icon")), forecast: forecastWeatherResposeWeatherAPICurrentHourly1x(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPICurrentHourly1x(hour: Array(repeating: hourlyDataWeatherAPICurrentHourly1x(time_epoch: 01, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "000", chance_of_snow: "000", vis_km: 0, condition: hourlyDataWeatherWeatherAPICurrentHourly1x(text: "Tex", icon: "Icon")), count: 24)), count: 1))))
        
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ModelCurrentHourly1x>) -> Void) {
        HourlyForCH1xDataRequest { (modelData) in
            let date = Date()
            let data = ModelCurrentHourly1x(date: date, response: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30,to: date)
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> ModelCurrentHourly1x {
        let loadingData = ModelCurrentHourly1x(date: Date(), response: WeatherResponseWeatherCurrentHourly1x(location: locationNameCurrentHourly1x(name: "Current"), current: currentDataWeatherAPICurrentHourly1x(temp_c: 0, wind_kph: 0, pressure_mb: 00, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPICurrentHourly1x(text: "Text", icon: "Icon")), forecast: forecastWeatherResposeWeatherAPICurrentHourly1x(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPICurrentHourly1x(hour: Array(repeating: hourlyDataWeatherAPICurrentHourly1x(time_epoch: 01, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "000", chance_of_snow: "000", vis_km: 0, condition: hourlyDataWeatherWeatherAPICurrentHourly1x(text: "Tex", icon: "Icon")), count: 24)), count: 1))))
        
        
        return loadingData
    }
}


func HourlyForCH1xDataRequest(completion: @escaping(WeatherResponseWeatherCurrentHourly1x) -> ()) {
    
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

    var json: WeatherResponseWeatherCurrentHourly1x?
    do {
        json = try JSONDecoder().decode(WeatherResponseWeatherCurrentHourly1x.self, from: data)
        completion(json!)
    }
    catch {
        print("error: \(error)")
    }
    
    print("\(json!.location.name) WazapHourly")
}).resume()
}



struct ModelCurrentHourly1x: TimelineEntry {

   public var date: Date
    
   public var response: WeatherResponseWeatherCurrentHourly1x
}

struct WeatherResponseWeatherCurrentHourly1x: Codable {
    let location: locationNameCurrentHourly1x
    let current: currentDataWeatherAPICurrentHourly1x
    let forecast: forecastWeatherResposeWeatherAPICurrentHourly1x
}

struct locationNameCurrentHourly1x: Codable {
    let name: String
}

struct currentDataWeatherAPICurrentHourly1x: Codable {
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let vis_km: Float
    let condition: currentDataWeatherWeatherAPICurrentHourly1x
}

struct currentDataWeatherWeatherAPICurrentHourly1x: Codable {
    let text: String
    let icon: String
}

struct forecastWeatherResposeWeatherAPICurrentHourly1x: Codable {
    let forecastday: [forecastdayFor8DaysWeatherAPICurrentHourly1x]
}

struct forecastdayFor8DaysWeatherAPICurrentHourly1x: Codable {
    let hour: [hourlyDataWeatherAPICurrentHourly1x]
}

struct hourlyDataWeatherAPICurrentHourly1x: Codable {
    let time_epoch: Int
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let chance_of_rain: String
    let chance_of_snow: String
    let vis_km: Float
    let condition: hourlyDataWeatherWeatherAPICurrentHourly1x
}

struct hourlyDataWeatherWeatherAPICurrentHourly1x: Codable {
    let text: String
    let icon: String
}
