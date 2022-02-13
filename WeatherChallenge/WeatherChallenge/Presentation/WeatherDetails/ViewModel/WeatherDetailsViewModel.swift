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
    private let repository: SearchRepositoryProtocol
    private let cityName: String
    private var cancellables = Set<AnyCancellable>()
    
    init(cityName: String, repository: SearchRepositoryProtocol) {
        self.repository = repository
        self.cityName = cityName
    }
    
    var screenTitle: String {
        return cityName
    }
    
    func getCurrentWeatherDetails() {
        dataStatus = .loading
        repository.currentWeatherFor(name: cityName)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.dataStatus = .finished(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                self?.dataStatus = .finished(.success)
                self?.details = value.map { DetailsItemViewModel(city: $0) }
            })
            .store(in: &cancellables)
    }
    
}
