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
    var id:Int?
    mutating func addIDToCity(_ id:Int) {
        self.id = id
    }
}
