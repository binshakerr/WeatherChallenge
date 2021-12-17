//
//  SearchViewModel.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import Foundation

protocol SearchViewModelProtocol {
    var screenTitle: String {get}
    var searchBarPlaceHolder: String {get}
}

class SearchViewModel: SearchViewModelProtocol {
    
    
    let screenTitle = "Search"
    let searchBarPlaceHolder = "Enter city name to search.."
    
}
