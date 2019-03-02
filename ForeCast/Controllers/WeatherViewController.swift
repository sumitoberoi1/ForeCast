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
    
    let locationUtil = LocationUtil()
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
        sunriseLabel.text = "\(Date(timeIntervalSince1970:weather.sunRiseTimeUnix).toLocalTime())"
        sunsetLabel.text = "\(Date(timeIntervalSince1970:weather.sunSetTimeUnix).toLocalTime())"
    }
    
    func getForeCast() {
        guard let weather = self.weather else {return}
        ForeCast.getForeCastForCity(city: weather.city) { (f1, error) in
            self.foreCast = f1
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
            if let weatherDate = weather.weatherDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "H a"
                dateFormatter.timeZone = TimeZone.current
                return dateFormatter.string(from: weatherDate)
            } else {
                return ""
            }
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
            //TODO: Handle custom error
            self.weather = weather
        }
        
    }
}
