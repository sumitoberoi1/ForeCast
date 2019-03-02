//
//  WeatherViewController.swift
//  ForeCast
//
//  Created by sumit oberoi on 3/2/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var snowRainLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    var weather:Weather? {
        didSet {
            refreshUI()
        }
    }
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Weather.getWeather { (weather, error) in
            //TODO: Show Error
            self.weather = weather
        }
    }

    //MARK: Custom Methods
    func refreshUI() {
        guard let weather = weather else {return}
        placeLabel.text = "\(weather.city.name), \(weather.city.country)"
        weatherConditionLabel.text = "\(weather.currentTemp)°F, \(weather.main)"
        configSnowRainLabelForWeather(weather)
        guard let url = weather.iconURL else {return}
        weatherIconImageView.kf.setImage(with: url)
    }
    
    func configSnowRainLabelForWeather(_ weather:Weather) {
        var snowRainText:String?
        if let snow = weather.snowLast1Hr {
            snowRainText = "\(snow) mm"
        }
        if let rain = weather.rainLast1Hr {
            if let snowText = snowRainText {
                snowRainText = snowText + ","
            } else {
                snowRainText = "\(rain) mm"
            }
        }
        if let snowRainText = snowRainText {
            snowRainLabel.isHidden = false
            snowRainLabel.text = snowRainText
        } else {
            snowRainLabel.isHidden = true
        }
    }
}
