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
    init(json:JSON) {
        weatherArray = []
        if let jsonArray = json["list"].array {
            for json in jsonArray {
               // self.weatherArray.append(Weather(json: json))
            }
        }
    }
    static func getForeCast(completion:@escaping (ForeCast?,CustomError?) -> ()) {
        Network.shared.getForeCast { (response) in
            guard response.result.isSuccess else {
                completion(nil,CustomError(title: "Something Went wrong",
                                           description: "Request Failed with StatusCode \(response.response?.statusCode ?? 400)", code: response.response?.statusCode ?? 400))
                return
            }
            guard let responseDict = response.value as? [String: Any] else {
                completion(nil,CustomError(title: "Something Went Wrong", description: "Cannot understand recieved Data", code: 400))
                return
            }
            completion(ForeCast(json: JSON(responseDict)),nil)
        }
        
    }
}
