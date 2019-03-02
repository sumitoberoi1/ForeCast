//
//  Network.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/28/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
struct Network {
    static let shared = Network()
    public func getWeatherforLatitude(_ lat:Double,andlongitude lon:Double,completion:@escaping (DataResponse<Any>) -> ()) {
        guard let url = URL(string: "\(Constants.getWeatherURL)&lat=\(lat)&lon=\(lon)") else {return}
        Alamofire.request(url,
                          method: .get)
            .responseJSON { response in
                completion(response)
        }
    }
    public func getForeCastFor(_ city:City,completion:@escaping (DataResponse<Any>) -> ()) {
        guard let id = city.id,
            let url = URL(string: "\(Constants.foreCastURL)&id=\(id)") else {return}
        Alamofire.request(url,
                          method: .get)
            .responseJSON { response in
                completion(response)
        }
    }
    
}
