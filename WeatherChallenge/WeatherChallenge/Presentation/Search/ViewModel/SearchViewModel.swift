//
//  SearchViewModel.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import Combine
import CoreLocation

protocol SearchViewModelProtocol {
    var screenTitle: String { get }
    var searchBarPlaceHolder: String { get }
    var dataStatus: DataState? { get }
    var cities: [SearchResult]? { get }
    func searchCities(name: String)
    var numberOfRows: Int { get }
    func cityAt(_ index: Int)-> SearchResult?
    var selectedRow: Int? { get }
    var noResultsText: String { get }
    var searchCellIdentifier: String { get }
    var selectedCityName: String? { get }
    var geocodedAddress: String? { get }
    func reverseGeocodeLocation(_ location: CLLocation)
}

class SearchViewModel: SearchViewModelProtocol {
    
    private var repository: SearchRepositoryProtocol!
    @Published private(set) var dataStatus: DataState?
    @Published private(set) var cities: [SearchResult]?
    @Published var selectedRow: Int?
    @Published private(set) var geocodedAddress: String?

    let geocoder = CLGeocoder()
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    let screenTitle = "Search"
    let searchBarPlaceHolder = "Enter city name to search.."
    
    func searchCities(name: String) {
        selectedRow = nil
        dataStatus = .loading
        repository.searchCities(name: name)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.dataStatus = .finished(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                self?.dataStatus = .finished(.success)
                self?.cities = value
            })
            .store(in: &cancellables)
    }
    
    var numberOfRows: Int {
        return cities?.count ?? 0
    }
    
    func cityAt(_ index: Int)-> SearchResult? {
        return cities?[index]
    }
    
    let noResultsText = "No results found"
    let searchCellIdentifier = "searchCell"
    
    var selectedCityName: String? {
        guard let row = selectedRow else { return nil }
        return cities?[row].name
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) {
        dataStatus = .loading
        geocoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) in
            if let error = error {
                self?.dataStatus = .finished(.failure(error))
                return
            }

            guard let placemarks = placemarks, placemarks.count > 0 else {
                let placemarkError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "couldn't find your address, please type it."])
                self?.dataStatus = .finished(.failure(placemarkError))
                return
            }
            
            let placemark = placemarks[0]
            let locality = placemark.locality ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            let userLocationString = "\(locality), \(administrativeArea), \(country)"
            self?.dataStatus = .finished(.success)
            self?.geocodedAddress = userLocationString
        })
    }
    
}
