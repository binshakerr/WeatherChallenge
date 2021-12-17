//
//  WeatherDetails.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

struct WeatherDetails: Decodable {
    let last_updated_epoch: Double
    let last_updated: String
    let temp_c: Float
    let temp_f: Float
    let is_day: Int
    let condition: WeatherCondition
    let wind_mph: Float
    let wind_kph: Float
    let wind_degree: Float
    let wind_dir: String
    let pressure_mb: Float
    let pressure_in: Float
    let precip_mm: Float
    let precip_in: Float
    let humidity: Float
    let cloud: Float
    let feelslike_c: Float
    let feelslike_f: Float
    let vis_km: Float
    let vis_miles: Float
    let uv: Float
    let gust_mph: Float
    let gust_kph: Float
}
