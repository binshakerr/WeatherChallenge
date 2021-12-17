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
        let receivedAllValues = expectation(description: "all values received")
//        var recievedArray = [SearchResult]()
//        viewModel.searchCities(name: "london")
        viewModel.$cities.sink { completion in
            switch completion {
            case .finished:
                receivedAllValues.fulfill()
            case .failure:
                break
            }
        } receiveValue: { value in
//            recievedArray = value!
            XCTAssertNotNil(value)
            XCTAssertEqual(value?.count, 10)
        }.store(in: &cancellables)

        viewModel.searchCities(name: "london")
        
        //then
//        XCTAssertNotNil(recievedArray)
//        XCTAssertEqual(recievedArray.count, 10)
        //            XCTAssertEqual(result?.first?.name, "London, City of London, Greater London, United Kingdom")
        //            XCTAssertEqual(result!.last?.lat, 51.52)
        
        waitForExpectations(timeout: 1)
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
