//
//  SearchRepository.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchCities(name: String, completion: @escaping ([SearchResult]?, Error?)->())
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
    
}
