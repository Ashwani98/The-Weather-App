//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, cityChangedDelegate {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    let locationManager = CLLocationManager()
    let weatherData = WeatherDataModel()
    var conversionType = ["C","F","K"]
    var valueOfType = 0
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conversionButtonLabel: UIButton!
    
    // IBAction
    @IBAction func gpsButton(_ sender: Any) {
        if conversionButtonLabel.titleLabel?.text == "F"{
        viewDidLoad()
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Make sure initially the type of temperature is in Celcius", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got It!", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: conversion
    @IBAction func conversionButtonPressed(_ sender: UIButton) {
        updateValueOfType()
        convertedTemp()
        updateUIWithWeatherData()
        updateButtonLabel()
    }
    
    func convertedTemp(){
        var temp = weatherData.temperature
        print("\(valueOfType) ++ \(temp) ")
        if valueOfType == 1 {
            temp = ((temp * 9) / 5) + 32
        }
        else if valueOfType == 2 {
            temp = (((temp - 32) * 5) / 9) + 273.15
        }
        else{
            temp = temp - 273.15
        }
        weatherData.temperature = temp
    }
    
    
    func updateButtonLabel(){
        var value = valueOfType + 1
        if value > 2{
            value = 0
        }
        conversionButtonLabel.setTitle("\(conversionType[value])", for: .normal)
    }
    
    
    func updateValueOfType() {
        let value = valueOfType + 1
        if    value > 2{
                valueOfType = 0
        }
        else{
            valueOfType += 1
        }
    }
    
    // This is the IBAction that gets called when the user swipe up on the screen:
    @IBAction func swipedToChangeCity(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "changeCityName", sender: sender)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  location manager .
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameter: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON{
            response in
            if response.result.isSuccess {
                print(response.result.value!)
                self.updateWeatherData(data: JSON(response.result.value!))
            }
            else{
                //print(response.result.error)
                self.cityLabel.text = "network unavailable"
            }
        }
        
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
   
    
    func updateWeatherData(data: JSON){
        if let temp = data["main"]["temp"].double{
            weatherData.temperature = temp - 273.15
            weatherData.city = data["name"].stringValue
            weatherData.condition = data["weather"]["id"].intValue
            weatherData.weatherIcon = weatherData.updateWeatherIcon(condition: weatherData.condition)
            updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "data unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherData.city
        if valueOfType == 2{
            temperatureLabel.text = "\(Int(weatherData.temperature))\(conversionType[valueOfType])"
        }
        else{
            temperatureLabel.text = "\(Int(weatherData.temperature))°\(conversionType[valueOfType])"
        }
        weatherIcon.image = UIImage(named: weatherData.weatherIcon)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let dict = ["lat": latitude,"lon": longitude,"appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parameter: dict)
        }
        else{
            print("error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "gps error"
        
    }
    
    

    
    //MARK: - Change City Delegate methods
    
    
    func userEnteredCity(city: String) {
        valueOfType = 0
        let para = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameter: para)
        updateButtonLabel()
    }

    // this method get called automatically for preparing the segue and ensure that the new VC is ready to put on the screen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationvc = segue.destination as! ChangeCityViewController
            destinationvc.delegate = self
        }
    }
    
    
    
    
}


