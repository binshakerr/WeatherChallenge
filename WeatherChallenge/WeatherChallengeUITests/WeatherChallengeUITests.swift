//
//  WeatherChallengeUITests.swift
//  WeatherChallengeUITests
//
//  Created by Eslam Shaker on 17/12/2021.
//

import XCTest
@testable import WeatherChallenge

class WeatherChallengeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }

    func test_home_InitialState(){
        let searchBarPlaceholder = app.searchFields["Enter city name to search.."].placeholderValue
        XCTAssertEqual(searchBarPlaceholder, "Enter city name to search..")
        let goButton = app.buttons["Go!"]
        XCTAssertEqual(goButton.isEnabled, false)
    }
}
