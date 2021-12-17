//
//  MockSearchViewModel.swift
//  WeatherChallengeTests
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import Combine
@testable import WeatherChallenge

class MockSearchRepository: SearchRepositoryProtocol {
    
    private var networkHandler: NetworkHandlerProtocol
    private var testSession: URLSession

    init(networkHandler: NetworkHandlerProtocol, session: URLSession) {
        self.networkHandler = networkHandler
        self.testSession = session
    }
    
    func searchCities(name: String) -> AnyPublisher<[SearchResult], Error> {
        return Future<[SearchResult], Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let request = try WeatherService.searchCities(name: name).makeURLRequest()
                self.networkHandler.requestData(session: self.testSession, request: request, type: [SearchResult].self, completion: { (cities, error) in
                    promise(.success(cities ?? []))
                })
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func currentWeatherFor(name: String) -> AnyPublisher<City?, Error> {
        return Future<City?, Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let request = try WeatherService.currentWeather(name: name).makeURLRequest()
                self.networkHandler.requestData(session: self.testSession, request: request, type: City.self, completion: { (city, error) in
                    promise(.success(city))
                })
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

}
