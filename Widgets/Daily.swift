//
//  Daily.swift
//  WidgetsExtension
//
//  Created by Bogdan Grozyan on 25.11.2020.
//

import SwiftUI
import WidgetKit

struct DailyProvider: TimelineProvider {
    typealias Entry = ModelDaily
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let loadingData = ModelDaily(date: Date(), response: WeatherResponseWeatherDaily(location: locationNameFromWeather(name: "Current"), forecast: forecastForDayWeatherAPI(forecastday: Array(repeating: forecastDaysWeatherAPI(date_epoch: 01, day: dailyWeatherAPI(maxtemp_c: 0, mintemp_c: 0, avgtemp_c: 0, condition: dailyWeatherWeatherAPI(text: "Text"))), count: 8))))
        
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ModelDaily>) -> Void) {
        DailyDataRequest(completion: { (ModelData) in
                
            let date = Date()
            
            let data = ModelDaily(date: date, response: ModelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 3 , to: date)
            
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        })
    }
    
    func placeholder(in context: Context) -> ModelDaily {
        let loadingData = ModelDaily(date: Date(), response: WeatherResponseWeatherDaily(location: locationNameFromWeather(name: "Current"), forecast: forecastForDayWeatherAPI(forecastday: Array(repeating: forecastDaysWeatherAPI(date_epoch: 01, day: dailyWeatherAPI(maxtemp_c: 0, mintemp_c: 0, avgtemp_c: 0, condition: dailyWeatherWeatherAPI(text: "Text"))), count: 8))))
        
        
        return loadingData
    }
}


func DailyDataRequest(completion: @escaping(WeatherResponseWeatherDaily) -> ()) {
    
    let url =  "https://api.weatherapi.com/v1/forecast.json?key=4bb04dd4c8974b94b23135236200511&q=44.7404,33.853576&days=8"
    
URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
    
    guard let data = data, error == nil else {
        print("somethingWentWrongOpenDailyWidget")
        return
    }
    
    if error == nil {
        print("WidgetDaily - Works")
    } else {
        print("WidgetDaily - Error")
    }

    var json: WeatherResponseWeatherDaily?
    do {
        json = try JSONDecoder().decode(WeatherResponseWeatherDaily.self, from: data)
        completion(json!)
    }
    catch {
        print("error: \(error)")
    }
    
    print("\(json!.location.name) WazapDaily")
    
}).resume()
}


struct ModelDaily: TimelineEntry {

   public var date: Date
    
   public var response: WeatherResponseWeatherDaily
}

struct WeatherResponseWeatherDaily: Codable {
    let location: locationNameFromWeather
    let forecast: forecastForDayWeatherAPI
}

struct locationNameFromWeather: Codable {
    let name: String
}

struct forecastForDayWeatherAPI: Codable {
    let forecastday: [forecastDaysWeatherAPI]
}

struct forecastDaysWeatherAPI: Codable {
    let date_epoch: Int
    let day: dailyWeatherAPI
}

struct dailyWeatherAPI: Codable {
    let maxtemp_c: Float
    let mintemp_c: Float
    let avgtemp_c: Float
    let condition: dailyWeatherWeatherAPI
}

struct dailyWeatherWeatherAPI: Codable {
    let text: String
}
