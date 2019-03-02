//
//  City.swift
//  ForeCast
//
//  Created by sumit oberoi on 2/28/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import SwiftyJSON
struct City {
    let lat:Double?
    let lon:Double?
    let name:String?
    let country:String?
//    init(json:JSON) {
//        lat = json["coord"]["lat"].double ?? 0.0
//        lon = json["coord"]["lon"].double ?? 0.0
//        id = json["id"].int ?? 0
//        name = json["name"].string ?? ""
//        country = json["sys"]["country"].string ?? ""
//    }
}
