//
//  City.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

struct City: Decodable {
    let location: CityInfo
    let current: WeatherDetails
}
