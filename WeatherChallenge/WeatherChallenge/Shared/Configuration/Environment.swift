//
//  Environment.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let APIKey = "WEATHER_API_KEY"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let value = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return value
    }()
    
    // MARK: - Plist values
    static let baseURL: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return value
    }()
    
    static let APIKey: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.APIKey] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return value
    }()
    
    
}
