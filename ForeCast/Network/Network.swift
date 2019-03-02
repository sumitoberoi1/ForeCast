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
    public func getWeather(completion:@escaping (DataResponse<Any>) -> ()) {
        guard let url = URL(string: "\(Constants.getWeatherURL)") else {return}
        Alamofire.request(url,
                          method: .get)
            .responseJSON { response in
                completion(response)
        }
    }
    public func getForeCast(completion:@escaping (DataResponse<Any>) -> ()) {
        guard let url = URL(string: "\(Constants.foreCastURL)") else {return}
        Alamofire.request(url,
                          method: .get)
            .responseJSON { response in
                completion(response)
        }
    }
    
}
