//
//  LocationUtil.swift
//  ForeCast
//
//  Created by sumit oberoi on 3/2/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationUtilDelegate {
    func locationUpdatedForUtil(_ util:LocationUtil, withCity city: City)
}
class LocationUtil:NSObject {
    let locationManager = CLLocationManager()
    var delegate:LocationUtilDelegate?
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationUtil:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation =  locations.last else {return}
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            if let placemarks = placemarks, placemarks.count > 0, let placemark = placemarks.first {
                let city = City(lat: placemark.location?.coordinate.latitude, lon: placemark.location?.coordinate.longitude, name:"\(placemark.name ?? ""), \(placemark.locality ?? "")", country: placemark.country)
                self.delegate?.locationUpdatedForUtil(self, withCity: city)
            }
        }
        print(lastLocation.coordinate)
    }
}
