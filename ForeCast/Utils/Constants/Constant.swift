//
//  Constant.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/28/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
struct Constants {
    static let baseURL = "https://api.openweathermap.org/data"
    static let apiVersion = "2.5"
    static let apiKey = "8cdf42127b9043f5dcfe1af2bb9f93b4"
    static let weatherPath = "weather"
    static let foreCastPath = "forecast"
    static let unit = "imperial"
    static let getWeatherURL = "\(baseURL)/\(apiVersion)/\(weatherPath)?appid=\(apiKey)&units=\(unit)"
    static let foreCastURL = "\(baseURL)/\(apiVersion)/\(foreCastPath)?appid=\(apiKey)&units=\(unit)"
    static let imageIconURL = "http://openweathermap.org/img/w/"
    static let imageFormatPNG = ".png"
    
}
