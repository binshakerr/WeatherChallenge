//
//  SearchRepository.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchCities(name: String, completion: @escaping ([SearchResult]?, Error?)->())
    func currentWeatherFor(name: String, completion: @escaping (City?, Error?)->())
}

class SearchRepository: SearchRepositoryProtocol {
    
    private var networkHandler: NetworkHandlerProtocol!
    
    convenience init(networkHandler: NetworkHandlerProtocol) {
        self.init()
        self.networkHandler = networkHandler
    }
    
    func searchCities(name: String, completion: @escaping ([SearchResult]?, Error?)->()) {
        do {
            let request = try WeatherService.searchCities(name: name).makeURLRequest()
            networkHandler.requestData(session: .shared, request: request, type: [SearchResult].self, completion: { (cities, error) in
                completion(cities, error)
            })
        } catch let error {
            completion(nil, error)
        }
    }
    
    func currentWeatherFor(name: String, completion: @escaping (City?, Error?)->()) {
        do {
            let request = try WeatherService.currentWeather(name: name).makeURLRequest()
            networkHandler.requestData(session: .shared, request: request, type: City.self, completion: { (city, error) in
                completion(city, error)
            })
        } catch let error {
            completion(nil, error)
        }
    }
    
}
