//
//  SearchViewModelTests.swift
//  WeatherChallengeTests
//
//  Created by Eslam Shaker on 17/12/2021.
//

import XCTest
import Combine
@testable import WeatherChallenge

class SearchViewModelTests: XCTestCase {

    var logger: LoggerProtocol!
    var apiHandler: APIHandlerProtocol!
    var parser: ParserProtocol!
    var repository: SearchRepositoryProtocol!
    var networkHandler: NetworkHandlerProtocol!
    var viewModel: SearchViewModel!
    var data: Data!
    var testSession: URLSession!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        logger = Logger()
        apiHandler = APIHanndler(logger: logger)
        parser = Parser()
        networkHandler = NetworkHandler(apiHandler: apiHandler, logger: logger, parser: parser)
        cancellables = []
    }
    
    func test_searchCities_success() throws {
        //Given
        data = Utils.MockResponseType.searchResults.sampleDataFor(self)
        testSession = MockSessionBuilder.getMockSessionFor(data)
        repository = MockSearchRepository(networkHandler: networkHandler, session: testSession)
        viewModel = SearchViewModel(repository: repository)
        
        //when
        let expectation = XCTestExpectation(description: "Publishes values then finishes")
        var values: [SearchResult] = []
        viewModel.$cities.sink { value in
            if let completeValue = value {
                values = completeValue
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.searchCities(name: "london")
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertEqual(values.count, 10)
        XCTAssertEqual(values.first?.name, "London, City of London, Greater London, United Kingdom")
        XCTAssertEqual(values.last?.lat, 51.53)
    }
    
    func test_viewModel_InitialState(){
        repository = SearchRepository(networkHandler: networkHandler)
        viewModel = SearchViewModel(repository: repository)
        XCTAssertEqual(viewModel.screenTitle, "Search")
        XCTAssertEqual(viewModel.searchBarPlaceHolder, "Enter city name to search..")
        XCTAssertEqual(viewModel.searchCellIdentifier, "searchCell")
        XCTAssertEqual(viewModel.numberOfRows, 0)
        XCTAssertNil(viewModel.selectedCityName)
        XCTAssertEqual(viewModel.noResultsText, "No results found")
    }

}
