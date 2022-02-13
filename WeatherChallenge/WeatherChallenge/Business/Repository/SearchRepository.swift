//
//  SearchRepository.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import Combine

protocol SearchRepositoryProtocol {
    func searchCities(name: String) -> AnyPublisher<[SearchResult], Error>
    func currentWeatherFor(name: String) -> AnyPublisher<City?, Error>
}

class SearchRepository: SearchRepositoryProtocol {
    
    private let networkHandler: NetworkHandlerProtocol
    
    init(networkHandler: NetworkHandlerProtocol) {
        self.networkHandler = networkHandler
    }
    
    func searchCities(name: String) -> AnyPublisher<[SearchResult], Error> {
        return Future<[SearchResult], Error> { [weak self] promise in
            do {
                let request = try WeatherService.searchCities(name: name).makeURLRequest()
                self?.networkHandler.requestData(session: .shared, request: request, type: [SearchResult].self, completion: { (cities, error) in
                    promise(.success(cities ?? []))
                })
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func currentWeatherFor(name: String) -> AnyPublisher<City?, Error> {
        return Future<City?, Error> { [weak self] promise in
            do {
                let request = try WeatherService.currentWeather(name: name).makeURLRequest()
                self?.networkHandler.requestData(session: .shared, request: request, type: City.self, completion: { (city, error) in
                    promise(.success(city))
                })
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
}
