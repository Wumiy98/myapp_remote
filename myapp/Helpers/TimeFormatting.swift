//
//  TimeFormatting.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/3/23.
//

import Foundation

func calcTimeSince(date:Date) ->String{
    
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120 {
        return "\(minutes) minutes ago"
    }
    else if (minutes >= 120) && (hours < 48) {
        return "\(hours) hours ago"
    }
    else {
        return "\(days) days ago"
    }
}

func getDiaryTime(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM.YY"
    return formatter.string(from: date)
    }

func getDiaryTime2(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/YY"
    return formatter.string(from: date)
    }

extension Date {

    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 将星期一设置为一周的第一天
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let startOfWeek = calendar.date(from: components) else { fatalError("Invalid date components") }
        return startOfWeek
    }
     
    
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    var startOfYear: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components)!
    }
    
}

enum DateFilter: String, CaseIterable {
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
}

enum MyWeather: String, CaseIterable {
    case sunny = "sunny"
    case rain = "rain"
    case cloud = "cloud"
    case thunder = "thunder"
    case snow = "snow"
    case wind = "wind"
    
    var pickWeather: String{
        
        switch self{
                    case .sunny:
                        return "sun.max"
                    case .rain:
                        return  "cloud.rain"
                    case .cloud:
                        return  "cloud.fog"
                    case .thunder:
                        return "cloud.bolt"
                    case .snow:
                        return "cloud.snow"
                    case .wind:
                        return "wind"
            
            
            
        }
    }
}

