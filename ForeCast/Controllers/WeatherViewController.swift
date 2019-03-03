//
//  WeatherViewController.swift
//  ForeCast
//
//  Created by sumit oberoi on 3/2/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import UIKit
import Kingfisher
import Charts
import SCLAlertView
import SkeletonView
class WeatherViewController: UIViewController {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var snowRainLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var hourlyBarView: BarChartView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var visiblityLabel: UILabel!
    @IBOutlet weak var swindSpeedLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var moreInfoStackView: UIStackView!
    var animatedViews = [UIView]()
    let locationUtil = LocationUtil()
    
    public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation
    var foreCast:ForeCast? {
        didSet {
            setHourlyChartForForecast()
        }
    }
    var weather:Weather? {
        didSet {
            refreshUI()
            getForeCast()
        }
    }
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationUtil.delegate = self
        configChart()
        animatedViews = [placeLabel,weatherConditionLabel,snowRainLabel,moreInfoStackView,hourlyBarView]
        self.showSkeleton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK: Custom Methods
    
    func configChart() {
        hourlyBarView.noDataTextColor = UIColor.white
        hourlyBarView.noDataText = "No Hourly prediction available"
        hourlyBarView.tintColor = UIColor.white
    }
    
    func refreshUI() {
        guard let weather = weather else {return}
        placeLabel.text = "\(weather.city.name ?? ""), \(weather.city.country ?? "")"
        weatherConditionLabel.text = "\(weather.currentTemp)°F, \(weather.main)"
        configSnowRainLabelForWeather(weather)
        guard let url = weather.iconURL else {return}
        weatherIconImageView.kf.setImage(with: url)
        configLabelForWeather(weather)
    }
    
    func configLabelForWeather(_ weather:Weather) {
        humidityLabel.text = "\(humidityLabel.text ?? "") \(weather.humidity)%"
        pressureLabel.text = "\(pressureLabel.text ?? "") \(weather.pressure)hPa"
        tempRangeLabel.text = "\(weather.minTemp)°F - \(weather.maxTemp)°F"
        visiblityLabel.text = "\(visiblityLabel.text ?? "") \(weather.visiblity)metre"
        swindSpeedLabel.text = "\(swindSpeedLabel.text ?? "") \(weather.windSpeed)miles/hr"
        cloudinessLabel.text = "\(cloudinessLabel.text ?? "") \(weather.cloudiness)%"
        sunriseLabel.text = "\(Date(timeIntervalSince1970:weather.sunRiseTimeUnix).getHoursMinFormat())"
        sunsetLabel.text = "\(Date(timeIntervalSince1970:weather.sunSetTimeUnix).getHoursMinFormat())"
    }
    
    func showSkeleton() {
        let color = UIColor.midnightBlue
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        animatedViews.forEach {$0.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: color), animation: animation)}
    }
    
    func hideSkelton() {
        animatedViews.forEach{$0.hideSkeleton()}
    }
    
    func getForeCast() {
        guard let weather = self.weather else {return}
        ForeCast.getForeCastForCity(city: weather.city) { (f1, error) in
            if let customError = error {
                SCLAlertView().showError("\(customError.title ?? "")", subTitle: customError.errorDescription ?? "" + "in getting forecast")
            } else {
                self.foreCast = f1
            }
        }
    }
    
    func setHourlyChartForForecast() {
        guard let foreCast = foreCast else {return}
        let barChartDataEntries = foreCast.hourlyForeCast.enumerated().map { (arg) -> BarChartDataEntry in
            let (i, weather) = arg
            return BarChartDataEntry(x: Double(i), y: weather.currentTemp)
        }
        let chartDataSet = BarChartDataSet(values: barChartDataEntries, label: "Temprature in °F")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.setColor(#colorLiteral(red: 0.9333333333, green: 0.6196078431, blue: 0.4352941176, alpha: 1))
        let hoursData = foreCast.hourlyForeCast.map { (weather) -> String in
            return Date(timeIntervalSince1970: weather.lastCalulatedDateUnix).getHoursOnlyFormat()
        }
        hourlyBarView.xAxis.valueFormatter = IndexAxisValueFormatter(values:hoursData)
        hourlyBarView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        hourlyBarView.data = chartData
    }
    
    func configSnowRainLabelForWeather(_ weather:Weather) {
        var snowRainText:String?
        if let snow = weather.snowLast1Hr {
            snowRainText = " Snow: \(snow) mm"
        }
        if let rain = weather.rainLast1Hr {
            if let snowText = snowRainText {
                snowRainText = snowText + ","
            } else {
                snowRainText = "Rain: \(rain) mm"
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


extension WeatherViewController:LocationUtilDelegate {
    func locationUpdatedForUtil(_ util: LocationUtil, withCity city: City) {
        Weather.getWeatherForCity(city) { (weather, customError) in
            self.hideSkelton()
            if let customError = customError {
                SCLAlertView().showError("\(customError.title ?? "")", subTitle: customError.errorDescription ?? "")
            } else {
                self.weather = weather
            }
        }
        
    }
}
