//
//  ForeCast.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/28/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import SwiftyJSON
struct ForeCast {
    var weatherArray:[Weather]
    var sortedWeatherArray:[Weather] {
        get {
            var aWeatherArray = weatherArray
            aWeatherArray.sort(by: { (w1, w2) -> Bool in
                if let w1date = w1.weatherDate, let w2Date = w2.weatherDate {
                    return w1date.timeIntervalSince(w2Date) < 0
                } else {
                    if w1.weatherDate != nil {
                        return true
                    } else {
                        return false
                    }
                }
            })
            return aWeatherArray
        }
    }
    
    var hourlyForeCast:[Weather] {
        get {
            return sortedWeatherArray.filter { (w1) -> Bool in
                guard let weatherDate = w1.weatherDate else {
                    return false
                }
                if let hoursDifference = Calendar.current.dateComponents([.hour], from: weatherDate, to: Date()).hour {
                    return hoursDifference <= 24
                }
                return false
            }
        }
    }
    
    init(json:JSON, city:City) {
        weatherArray = []
        if let jsonArray = json["list"].array {
            for json in jsonArray {
                self.weatherArray.append(Weather(json: json, city: city))
            }
        }
    }
    static func getForeCastForCity(city:City,completion:@escaping (ForeCast?,CustomError?) -> ()) {
        Network.shared.getForeCastFor(city) { (response) in
            guard response.result.isSuccess else {
                completion(nil,CustomError(title: "Something Went wrong",
                                           description: "Request Failed with StatusCode \(response.response?.statusCode ?? 400)", code: response.response?.statusCode ?? 400))
                return
            }
            guard let responseDict = response.value as? [String: Any] else {
                completion(nil,CustomError(title: "Something Went Wrong", description: "Cannot understand recieved Data", code: 400))
                return
            }
            completion(ForeCast(json: JSON(responseDict), city: city),nil)
        }
        
    }
}
