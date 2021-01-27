//
//  Current.swift
//  WidgetsExtension
//
//  Created by Bogdan Grozyan on 24.11.2020.
//

import WidgetKit
import SwiftUI


@main
struct CloudlyWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    
    var body: some Widget {
        MainCurrentWidget()
        MainHourlyWidget()
        MainDailyWidget()
        MainCurrentHourl1xWidget()
        CurrentHourlyDaily2xWidget()
    }
}


//MARK: Current
struct MainCurrentWidget: Widget {
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "Current", provider: Provider()) { data in
            WidgetView(data: data)
        } .supportedFamilies([.systemSmall])
        .configurationDisplayName("Current")
        .description("Show current weather")
    }
}

struct WidgetView: View {
    var data: Model
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Bakhchisarai")
                .font(.system(size: 24))
            VStack{
                Text(data.response.current.condition.text)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            Text("\(Int(data.response.current.temp_c))°")
                .font(.system(size: 24))
            HStack {
                VStack(alignment: .leading){
                    Text("\(Int(data.response.current.humidity))%")
                    
                    Text("\(Int(data.response.current.pressure_mb / 1000))k")
                }
                VStack {
                    Image(systemName: "drop")
                    
                    Image(systemName: "arrow.down.to.line.alt")
                }
                VStack(alignment: .leading) {
                    Text("\(Int(data.response.current.wind_kph))km")
                    
                    Text("\(Int(data.response.current.vis_km))km")
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                VStack {
                    Image(systemName: "wind")
                    
                    Image(systemName: "eye")
                }
            }
        }
    }
}


//MARK: Hourly
struct MainHourlyWidget: Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Hourly", provider: HourlyProvider()) { data in
            HourlyWidgetView(data: data)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Hourly")
        .description("Show hourly forecast")
    }
}

struct HourlyWidgetView: View {
    var data: ModelHourly
    
    var body: some View {
        
        VStack {
            //
            Text("Bahchisarai")
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[0].time_epoch))))")
                        .font(.system(size: 12))
                    Text("\(data.response.forecast.forecastday[0].hour[0].condition.text)")
                        .scaledToFit()
                        .lineLimit(2)
                    Text("\(Int(data.response.forecast.forecastday[0].hour[0].temp_c))°")
                        .font(.system(size: 12))
                    VStack(alignment: .leading) {
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[3].time_epoch))))")
                            .font(.system(size: 12))
                        Text("\(data.response.forecast.forecastday[0].hour[3].condition.text)")
                            .scaledToFit()
                            .lineLimit(2)
                        Text("\(Int(data.response.forecast.forecastday[0].hour[3].temp_c))°")
                            .font(.system(size: 12))
                    }
                }
                VStack(alignment: .leading) {
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[1].time_epoch))))")
                        .font(.system(size: 12))
                    Text("\(data.response.forecast.forecastday[0].hour[1].condition.text)")
                        .scaledToFit()
                        .lineLimit(2)
                    Text("\(Int(data.response.forecast.forecastday[0].hour[1].temp_c))°")
                        .font(.system(size: 12))
                    VStack{
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[4].time_epoch))))")
                            .font(.system(size: 12))
                        Text("\(data.response.forecast.forecastday[0].hour[4].condition.text)")
                            .scaledToFit()
                            .lineLimit(2)
                        Text("\(Int(data.response.forecast.forecastday[0].hour[4].temp_c))°")
                            .font(.system(size: 12))
                    }
                }
                VStack(alignment: .leading) {
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[2].time_epoch))))")
                        .font(.system(size: 12))
                    Text("\(data.response.forecast.forecastday[0].hour[2].condition.text)")
                        .scaledToFit()
                        .lineLimit(2)
                    Text("\(Int(data.response.forecast.forecastday[0].hour[2].temp_c))°")
                        .font(.system(size: 12))
                    VStack(alignment: .leading) {
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[5].time_epoch))))")
                            .font(.system(size: 12))
                        Text("\(data.response.forecast.forecastday[0].hour[5].condition.text)")
                            .scaledToFit()
                            .lineLimit(2)
                        Text("\(Int(data.response.forecast.forecastday[0].hour[5].temp_c))°")
                            .font(.system(size: 12))
                    }
                }
            }
        }
    }
}


//MARK: Daily
struct MainDailyWidget: Widget {
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "Daily", provider: DailyProvider()) { data in
            DailyWidgetView(data: data)
        } .supportedFamilies([.systemSmall])
        .configurationDisplayName("Daily")
        .description("Show daily weather")
    }
}


struct DailyWidgetView: View {
    var data: ModelDaily
    
    var body: some View {
        
        VStack {
            
            Text("Bahchisarai")
            
            HStack {
                VStack{
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].date_epoch))))")
                        .font(.system(size: 14))
                    Image("\(data.response.forecast.forecastday[0].day.condition.text )")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[0].day.maxtemp_c)°")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[0].day.mintemp_c)°")
                        .font(.system(size: 14))
                    VStack{
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[4].date_epoch))))")
                            .font(.system(size: 14))
                        Image("\(data.response.forecast.forecastday[4].day.condition.text )")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[4].day.maxtemp_c)°")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[4].day.mintemp_c)°")
                            .font(.system(size: 14))
                    }
                }
                
                VStack{
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[1].date_epoch))))")
                        .font(.system(size: 14))
                    Image("\(data.response.forecast.forecastday[1].day.condition.text )")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[1].day.maxtemp_c)°")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[1].day.mintemp_c)°")
                        .font(.system(size: 14))
                    VStack{
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[5].date_epoch))))")
                            .font(.system(size: 14))
                        Image("\(data.response.forecast.forecastday[5].day.condition.text )")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[5].day.maxtemp_c)°")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[5].day.mintemp_c)°")
                            .font(.system(size: 14))
                    }
                }
                
                VStack{
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[2].date_epoch))))")
                        .font(.system(size: 14))
                    Image("\(data.response.forecast.forecastday[2].day.condition.text )")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[2].day.maxtemp_c)°")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[2].day.mintemp_c)°")
                        .font(.system(size: 14))
                    VStack{
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[6].date_epoch))))")
                            .font(.system(size: 14))
                        Image("\(data.response.forecast.forecastday[6].day.condition.text )")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[6].day.maxtemp_c)°")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[6].day.mintemp_c)°")
                            .font(.system(size: 14))
                    }
                }
                VStack{
                    
                    Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[3].date_epoch))))")
                        .font(.system(size: 14))
                    Image("\(data.response.forecast.forecastday[3].day.condition.text )")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[3].day.maxtemp_c)°")
                        .font(.system(size: 14))
                    Text("\(data.response.forecast.forecastday[3].day.mintemp_c)°")
                        .font(.system(size: 14))
                    
                    VStack{
                        
                        Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[7].date_epoch))))")
                            .font(.system(size: 14))
                        Image("\(data.response.forecast.forecastday[7].day.condition.text )")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[7].day.maxtemp_c)°")
                            .font(.system(size: 14))
                        Text("\(data.response.forecast.forecastday[7].day.mintemp_c)°")
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
}

struct MainCurrentHourl1xWidget: Widget {
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "Current and Hourly", provider: CurrentHourly1xProvider()) { data in
            CurrentHourly1xWidgetView(data: data)
        } .supportedFamilies([.systemSmall])
        .configurationDisplayName("Current and Hourly")
        .description("Show current and for 6 hours weather")
    }
}

struct CurrentHourly1xWidgetView: View {
    var data: ModelCurrentHourly1x
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            
            //Current
            Text("Bakhchisarai")
                .font(.system(size: 24))
            VStack{
                Text(data.response.current.condition.text)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            Text("\(Int(data.response.current.temp_c))°")
                .font(.system(size: 24))
            }
        
        
        //Hourly for 6H
        HStack {
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[1].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[1].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[1].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[2].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[2].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[2].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[3].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[3].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[3].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[4].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[4].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[4].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[5].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[5].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[5].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[6].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[6].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[6].temp_c)°")
                    .font(.system(size: 14))
            
            }
            
        }
        
    }
}



struct CurrentHourlyDaily2xWidget: Widget {
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "Current and Hourly", provider: CurrentHourlyDaily2xProvider()) { data in
            CurrentHourlyDaily2xWidgetView(data: data)
        } .supportedFamilies([.systemMedium])
        .configurationDisplayName("Current Hourly and Daily")
        .description("Show current and for 6 hours and for 4 days weather") //MARK: Change
    }
}

struct CurrentHourlyDaily2xWidgetView: View {
    var data: ModelCurrentHourlyDaily2x
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            
            //Current
            Text("Bakhchisarai")
                .font(.system(size: 24))
            VStack{
                Text(data.response.current.condition.text)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            }
            Text("\(Int(data.response.current.temp_c))°")
                .font(.system(size: 24))
            
        
        
        //Hourly for 6H
        HStack {
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[1].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[1].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[1].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[2].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[2].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[2].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[3].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[3].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[3].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[4].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[4].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[4].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[5].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[5].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[5].temp_c)°")
                    .font(.system(size: 14))
            }
            VStack{
                
                Text("\(getDayForDate(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[6].time_epoch))))")
                    .font(.system(size: 14))
                Image("\(data.response.forecast.forecastday[0].hour[6].condition.text)")
                    .font(.system(size: 14))
                Text("\(data.response.forecast.forecastday[0].hour[6].temp_c)°")
                    .font(.system(size: 14))
            
            }
        }
            HStack {
                
                Text("\(getDayForDateDaily(Date(timeIntervalSince1970: Double(data.response.forecast.forecastday[0].hour[5].time_epoch))))") //Change
                
                
                //MARK: addMore
            }
        }
    }
}



func getDayForDateDaily(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "EEE" // Mon
    return formatter.string(from: inputDate)
}



func getDayForDate(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h a" // 2 pm
    return formatter.string(from: inputDate)
}
