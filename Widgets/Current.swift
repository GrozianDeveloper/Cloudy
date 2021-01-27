//
//  Widgets.swift
//  Widgets
//
//  Created by Bogdan Grozyan on 20.11.2020.
//

import SwiftUI
import WidgetKit



struct Provider: TimelineProvider {
    typealias Entry = Model
    func placeholder(in context: Context) -> Model {
        let loadingData = Model(date: Date(), response: WeatherResponseWeatherAPI(location: locationName(name: "Current"), current: currentDataWeatherAPI(temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPI(text: "Text", icon: "Sun"))))
        //
        return loadingData
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingData = Model(date: Date(), response: WeatherResponseWeatherAPI(location: locationName(name: "Current"), current: currentDataWeatherAPI(temp_c: 0, wind_kph: 0, pressure_mb: 0, humidity: 0, feelslike_c: 0, vis_km: 0, condition: currentDataWeatherWeatherAPI(text: "Text", icon: "Sun"))))
        //
        completion(loadingData)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        dataWeatherAPIRequest { (modelData) in
            let date = Date()
            let data = Model(date: date, response: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30,to: date)
            //
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        }
    }
    
}


func dataWeatherAPIRequest(completion: @escaping(WeatherResponseWeatherAPI) -> ()) {
    
    let url =  "https://api.weatherapi.com/v1/forecast.json?key=4bb04dd4c8974b94b23135236200511&q=44.7404,33.853576"
    
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

    var json: WeatherResponseWeatherAPI?
    do {
        json = try JSONDecoder().decode(WeatherResponseWeatherAPI.self, from: data)
        completion(json!)
    }
    catch {
        print("error: \(error)")
    }
    
    print("\(json!.location) WazapCurrent")
}).resume()
}

struct Model: TimelineEntry {
    public var date: Date
    
    public var response: WeatherResponseWeatherAPI
    }


struct WeatherResponseWeatherAPI: Codable {
    let location: locationName
    let current: currentDataWeatherAPI
}

struct locationName: Codable {
    let name: String
}

struct currentDataWeatherAPI: Codable {
    let temp_c: Float
    let wind_kph: Float
    let pressure_mb: Float
    let humidity: Float
    let feelslike_c: Float
    let vis_km: Float
    let condition: currentDataWeatherWeatherAPI
}

struct currentDataWeatherWeatherAPI: Codable {
    let text: String
    let icon: String
}
