//
//  ForDay.swift
//  WidgetsExtension
//
//  Created by Bogdan Grozyan on 24.11.2020.
//
import Foundation
import SwiftUI
import WidgetKit


struct HourlyProvider: TimelineProvider {
    typealias Entry = ModelHourly
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingData = ModelHourly(date: Date(), response: HourlyResponseWeather(location: HourlylocationName(name: "Current"), forecast: forecastWeatherResposeWeatherAPI(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPI(hour: Array(repeating: hourlyDataWeatherAPI(time_epoch: 01, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "000", chance_of_snow: "000", vis_km: 0, condition: hourlyDataWeatherWeatherAPI(text: "Text", icon: "Sun")), count: 24)), count: 3))))
        
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ModelHourly>) -> Void) {
        hourlyDataRequest(completion: { (ModelData) in
            let date = Date()
            
            let data = ModelHourly(date: date, response: ModelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1 , to: date)
            
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        })
    }
    
    func placeholder(in context: Context) -> ModelHourly {
        let loadingData = ModelHourly(date: Date(), response: HourlyResponseWeather(location: HourlylocationName(name: "Current"), forecast: forecastWeatherResposeWeatherAPI(forecastday: Array(repeating: forecastdayFor8DaysWeatherAPI(hour: Array(repeating: hourlyDataWeatherAPI(time_epoch: 01, temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, chance_of_rain: "000", chance_of_snow: "000", vis_km: 0, condition: hourlyDataWeatherWeatherAPI(text: "Text", icon: "Sun")), count: 24)), count: 3))))
        //
        return loadingData
    }
}




func hourlyDataRequest(completion: @escaping(HourlyResponseWeather) -> ()) {
    
    let url =  "https://api.weatherapi.com/v1/forecast.json?key=4bb04dd4c8974b94b23135236200511&q=44.7404,33.853576&days=8"
    
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

    var json: HourlyResponseWeather?
    do {
        json = try JSONDecoder().decode(HourlyResponseWeather.self, from: data)
        completion(json!)
    }
    catch {
        print("error: \(error)")
    }
    
    print("\(json!.location.name) WazapHourly")
}).resume()
}
struct ModelHourly: TimelineEntry {

   public var date: Date
    
   public var response: HourlyResponseWeather
}


struct HourlyResponseWeather: Codable {
    let location: HourlylocationName
    
    let forecast: forecastWeatherResposeWeatherAPI
}

struct HourlylocationName: Codable {
    let name: String
}

struct forecastWeatherResposeWeatherAPI: Codable {
    let forecastday: [forecastdayFor8DaysWeatherAPI]
}

struct forecastdayFor8DaysWeatherAPI: Codable {
    let hour: [hourlyDataWeatherAPI]
}

struct hourlyDataWeatherAPI: Codable {
    let time_epoch: Int
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let chance_of_rain: String
    let chance_of_snow: String
    let vis_km: Float
    let condition: hourlyDataWeatherWeatherAPI
}

struct hourlyDataWeatherWeatherAPI: Codable {
    let text: String
    let icon: String
}


