//
//  WeatherDataManager.swift
//  MyWeatherApp
//
//  Created by Beni Ibeh on 12/01/2019.
//  Copyright © 2019 Beni Ibeh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage
import SDWebImage


class WeatherDataManager  {
    
    var url = "http://api.openweathermap.org/data/2.5/weather"
    var iconUrl = "http://openweathermap.org/img/w/"
    
    func getWeatherForLocation(locationsArray : [String]){

        locationsArray.forEach { (location) in
            let params : [String: String] = ["q":location, "APPID":Api.key,"units":"metric"]
            Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
                
                let weatherData :JSON = JSON(response.result.value!)
                let weatherIcon = self.getWeatherIcon(icon: weatherData["weather"][0]["icon"].stringValue)
                let weatherDescription = weatherData["weather"][0]["description"].stringValue
                let weather = weatherData["weather"][0]["main"].stringValue
                let locationName = weatherData["name"].stringValue
                let weatherTemperature = weatherData["main"]["temp"].stringValue
                self.updateWeatherArrayWithData(weather: weather, weatherDescription: weatherDescription, weatherIcon: weatherIcon, locationName: locationName, temperature: weatherTemperature)
            }
        }


    }
    
    func updateWeatherArrayWithData(weather: String, weatherDescription: String, weatherIcon:UIImageView,locationName: String,temperature:String){
        let weatherInfo = CustomCollectionViewCell(weatherIcon: weatherIcon, weather: weather, weatherLocation: locationName, temperature: temperature)
        savedLocation.append(weatherInfo)

    }
    
    fileprivate func getWeatherIcon(icon: String)-> UIImageView{
        let imageIcon = UIImageView()
         let url = iconUrl+icon+".png"
          imageIcon.sd_setImage(with:URL(string:url), placeholderImage: UIImage(named: "placeholder.png"))
        return imageIcon
    }
}
