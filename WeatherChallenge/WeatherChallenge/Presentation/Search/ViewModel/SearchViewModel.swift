//
//  SearchViewModel.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation
import Combine

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
}

class SearchViewModel: SearchViewModelProtocol {
    
    private var repository: SearchRepositoryProtocol!
    @Published private(set) var dataStatus: DataState?
    @Published private(set) var cities: [SearchResult]?
    @Published var selectedRow: Int?
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    let screenTitle = "Search"
    let searchBarPlaceHolder = "Enter city name to search.."
    
    func searchCities(name: String) {
        selectedRow = nil
        dataStatus = .loading
        repository.searchCities(name: name) { [weak self] result, error in
            if let error = error {
                self?.dataStatus = .finished(.failure(error))
            } else {
                self?.dataStatus = .finished(.success)
                self?.cities = result ?? []
            }
        }
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
    
}
