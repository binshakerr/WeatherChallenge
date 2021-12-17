//
//  WeatherCondition.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

struct WeatherCondition: Decodable {
    let text: String
    let icon: String
    let code: Int 
}
