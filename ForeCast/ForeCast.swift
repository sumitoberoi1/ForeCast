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
                w1.lastCalulatedDateUnix-w2.lastCalulatedDateUnix < 0
            })
            return aWeatherArray
        }
    }
    
    var hourlyForeCast:[Weather] {
        get {
            return sortedWeatherArray.filter { (w1) -> Bool in
                let hoursDifference = ((w1.lastCalulatedDateUnix - Date().timeIntervalSince1970)/60)/60
                return hoursDifference <= 24
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
            if let statusCode = response.response?.statusCode {
                if (statusCode >= 200 && statusCode <= 300) {
                     completion(ForeCast(json: JSON(responseDict), city: city),nil)
                } else {
                    completion(nil,CustomError(title: "Something Went Wrong", description: "Status Code: \(statusCode)", code: statusCode))
                    return
                }
                
            } else {
                completion(nil,CustomError(title: "Something Went Wrong", description: "Cannot understand recieved Data", code: 400))
                return
            }
        }
        
    }
}
