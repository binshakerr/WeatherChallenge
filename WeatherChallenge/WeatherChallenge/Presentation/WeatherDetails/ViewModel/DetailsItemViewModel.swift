//
//  DetailsItemViewModel.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import CoreLocation

//light wight item for displaying only the required information from a city model

struct DetailsItemViewModel {
    let temperature: String
    let pressure: String
    let humidity: String
    let conditionImage: String
    let chanceOfPrecipitation: String
    let location: CLLocation
    
    init(city: City){
        temperature = "\(city.current.temp_f)°F"
        pressure = "\(city.current.pressure_mb) hPa"
        humidity = "\(city.current.humidity)%"
        chanceOfPrecipitation = "\(city.current.precip_mm)%"
        conditionImage = "https:\(city.current.condition.icon)"
        let long = city.location.lon
        let lat = city.location.lat
        location = CLLocation(latitude: lat, longitude: long)
    }
}
