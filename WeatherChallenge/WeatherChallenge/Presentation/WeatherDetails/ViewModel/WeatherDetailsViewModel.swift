//
//  WeatherDetailsViewModel.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import Combine

protocol WeatherDetailsViewModelProtocol {
    var screenTitle: String { get }
    func getCurrentWeatherDetails()
    var dataStatus: DataState? { get }
    var details: DetailsItemViewModel? { get }
}

class WeatherDetailsViewModel: WeatherDetailsViewModelProtocol {
    
    @Published private(set) var dataStatus: DataState?
    @Published private(set) var details: DetailsItemViewModel?
    
    private var repository: SearchRepositoryProtocol!
    private var cityName: String!
    
    init(cityName: String, repository: SearchRepositoryProtocol) {
        self.repository = repository
        self.cityName = cityName
    }
    
    var screenTitle: String {
        return cityName
    }
    
    func getCurrentWeatherDetails() {
        dataStatus = .loading
        repository.currentWeatherFor(name: cityName) { [weak self] result, error in
            if let error = error {
                self?.dataStatus = .finished(.failure(error))
            } else {
                self?.dataStatus = .finished(.success)
                self?.details = result.map { DetailsItemViewModel(city: $0) }
            }
        }
    }
    
}
