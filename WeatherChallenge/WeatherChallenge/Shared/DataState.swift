//
//  DataState.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

enum DataState {
    case loading
    case finished(Outcome)
        
    enum Outcome {
        case failure(Error)
        case success
    }
}
