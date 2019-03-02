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
            return URL(string:"\(Constants.imageIconURL)\(iconCode)\(Constants.imageFormatPNG)")
        }
    }
    init(json:JSON,city:City) {
        currentTemp = json["main"]["temp"].double ?? 0.0
        let mainJSON = json["main"]
        maxTemp = mainJSON["temp_max"].double ?? 0.0
        minTemp = mainJSON["temp_min"].double ?? 0.0
        pressure = mainJSON["pressure"].double ?? 0.0
        humidity = mainJSON["humidity"].double ?? 0.0
        windSpeed = json["wind"]["speed"].double ?? 0.0
        cloudiness = json["clouds"]["all"].double ?? 0.0
        rainLast1Hr = json["rain"]["1h"].double
        snowLast1Hr = json["snow"]["1h"].double
        let weatherJSON = json["weather"][0]
        id = weatherJSON["id"].int ?? 0
        main = weatherJSON["main"].string ?? ""
        desc = weatherJSON["description"].string ?? ""
        iconCode = weatherJSON["icon"].string ?? ""
        lastCalulatedDateUnix = json["dt"].double ?? 0.0
        sunSetTimeUnix = json["sys"]["sunset"].double ?? 0.0
        sunRiseTimeUnix = json["sys"]["sunrise"].double ?? 0.0
        self.city = city
    }
    static func getWeatherForCity(_ city:City,completion:@escaping (Weather?,CustomError?) -> ()) {
        guard let lat = city.lat, let lon = city.lon else {
            completion(nil,CustomError(title: "Location error", description: "Cannot find Latitude and Longitude", code: 400))
            return
        }
        Network.shared.getWeatherforLatitude(lat, andlongitude: lon) { (response) in
            guard response.result.isSuccess else {
                completion(nil,CustomError(title: "Something Went wrong",
                                           description: "Request Failed with StatusCode \(response.response?.statusCode ?? 400)", code: response.response?.statusCode ?? 400))
                return
            }
            guard let responseDict = response.value as? [String: Any] else {
                completion(nil,CustomError(title: "Something Went Wrong", description: "Cannot understand recieved Data", code: 400))
                return
            }
            completion(Weather(json: JSON(responseDict), city: city),nil)
        }
}
}
