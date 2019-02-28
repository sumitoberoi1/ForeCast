//
//  Weather.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/27/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation

struct Weather {
    let currentTemp:Double
    let maxTemp:Double
    let minTemp: Double
    let pressure:Double
    let humidity:Double
    let windSpeed:Double
    let cloudiness:Double
    let rainLast1Hr:Double
    let rainLast3Hr:Double
    let snowLast1Hr:Double
    let snowLast3Hr:Double
    let id:Int
    let main:String
    let desc:String
    let lastCalulatedDate:Double
    let city:City
    private let iconCode:String
    var iconURL:URL? {
        get {
            return URL(string:"http://openweathermap.org/img/w/\(iconCode).png")
        }
    }
}
