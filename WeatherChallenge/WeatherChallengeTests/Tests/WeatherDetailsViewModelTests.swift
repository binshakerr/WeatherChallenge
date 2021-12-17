//
//  WeatherDetailsViewModelTests.swift
//  WeatherChallengeTests
//
//  Created by Eslam Shaker on 17/12/2021.
//

import XCTest
import Combine
@testable import WeatherChallenge

class WeatherDetailsViewModelTests: XCTestCase {

    var logger: LoggerProtocol!
    var apiHandler: APIHandlerProtocol!
    var parser: ParserProtocol!
    var repository: SearchRepositoryProtocol!
    var networkHandler: NetworkHandlerProtocol!
    var viewModel: WeatherDetailsViewModel!
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
    
    func test_getCityDetails(){
        //Given
        data = Utils.MockResponseType.weatherDetails.sampleDataFor(self)
        testSession = MockSessionBuilder.getMockSessionFor(data)
        repository = MockSearchRepository(networkHandler: networkHandler, session: testSession)
        viewModel = WeatherDetailsViewModel(cityName: "London, City of London, Greater London, United Kingdom", repository: repository)
        
        //when
        let expectation = XCTestExpectation(description: "Publishes values then finishes")
        var values: DetailsItemViewModel?
        viewModel.$details.sink { value in
            if let completeValue = value {
                values = completeValue
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.getCurrentWeatherDetails()
        wait(for: [expectation], timeout: 3)
        
        //then
        XCTAssertNotNil(values)
        XCTAssertEqual(values?.humidity, "87.0%")
        XCTAssertEqual(values?.pressure, "1041.0 hPa")
        XCTAssertEqual(values?.temperature, "46.4°F")
    }
    
    func test_viewModel_InitialState(){
        repository = SearchRepository(networkHandler: networkHandler)
        viewModel = WeatherDetailsViewModel(cityName: "London, City of London, Greater London, United Kingdom", repository: repository)
        XCTAssertEqual(viewModel.screenTitle, "London, City of London, Greater London, United Kingdom")
    }

}
