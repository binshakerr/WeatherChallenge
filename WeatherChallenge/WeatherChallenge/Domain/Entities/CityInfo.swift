//
//  CityInfo.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

struct CityInfo: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Double
    let localtime: String
}
