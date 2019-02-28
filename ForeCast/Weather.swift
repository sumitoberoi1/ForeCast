//
//  Weather.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/27/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Weather {
    let currentTemp:Double
    let maxTemp:Double
    let minTemp: Double
    let pressure:Double
    let humidity:Double
    let windSpeed:Double
    let cloudiness:Double
    let rainLast1Hr:Double?
    let snowLast1Hr:Double?
    let id:Int
    let main:String
    let desc:String
    let lastCalulatedDateUnix:Double
    let city:City
    let sunSetTimeUnix:Double
    let sunRiseTimeUnix:Double
    private let iconCode:String
    var iconURL:URL? {
        get {
            return URL(string:"\(Constants.imageIconURL)\(iconCode).\(Constants.imageFormatPNG)")
        }
    }
    init(json:JSON) {
        currentTemp = json["main"]["temp"].double ?? 0.0
        maxTemp = json["main"]["temp_max"].double ?? 0.0
        minTemp = json["main"]["temp_min"].double ?? 0.0
        pressure = json["main"]["pressure"].double ?? 0.0
        humidity = json["main"]["humidity"].double ?? 0.0
        windSpeed = json["wind"]["speed"].double ?? 0.0
        cloudiness = json["clouds"]["all"].double ?? 0.0
        rainLast1Hr = json["rain"]["1h"].double
        snowLast1Hr = json["snow"]["1h"].double
        id = json["weather"][0]["id"].int ?? 0
        main = json["weather"][0]["main"].string ?? ""
        desc = json["weather"][0]["description"].string ?? ""
        iconCode = json["weather"][0]["icon"].string ?? ""
        lastCalulatedDateUnix = json["dt"].double ?? 0.0
        sunSetTimeUnix = json["sys"]["sunset"].double ?? 0.0
        sunRiseTimeUnix = json["sys"]["sunrise"].double ?? 0.0
        city = City(json: json)
    }
    static func getWeather(completion:@escaping (Weather?,CustomError?) -> ()) {
        Network.shared.getWeather { (response) in
            guard response.result.isSuccess else {
                completion(nil,CustomError(title: "Something Went wrong",
                                           description: "Request Failed with StatusCode \(response.response?.statusCode ?? 400)", code: response.response?.statusCode ?? 400))
                return
            }
            guard let responseDict = response.value as? [String: Any] else {
                completion(nil,CustomError(title: "Something Went Wrong", description: "Cannot understand recieved Data", code: 400))
                return
            }
            completion(Weather(json: JSON(responseDict)),nil)
        }
        
    }
}
