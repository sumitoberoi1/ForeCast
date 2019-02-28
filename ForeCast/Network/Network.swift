//
//  Network.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/28/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import Alamofire
struct Network {
    static let shared = Network(baseURLString: Constants.getWeatherURL)
    private let baseURLString:String
    public func getWeather() {
        guard let url = URL(string: "\(self.baseURLString)") else {return}
        Alamofire.request(url,
                          method: .get)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    return
                }
                print(response)
        }
    }
}
