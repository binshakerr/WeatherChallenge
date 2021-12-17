//
//  XCTest+Extensions.swift
//  WeatherChallengeTests
//
//  Created by Eslam Shaker on 17/12/2021.
//

import XCTest
import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )
        
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
    
//    typealias CompetionResult = (expectation: XCTestExpectation, cancellable: AnyCancellable)
//
//    func expectCompletion<T: Publisher>(of publisher: T,
//                                        timeout: TimeInterval = 2,
//                                        file: StaticString = #file,
//                                        line: UInt = #line) -> CompetionResult {
//        let exp = expectation(description: "Successful completion of " + String(describing: publisher))
//
//        let cancellable = publisher
//            .sink(receiveCompletion: { completion in
//                if case .finished = completion {
//                    exp.fulfill()
//                }
//            }, receiveValue: { _ in })
//
//        return (exp, cancellable)
//    }
//
//    func expectFailure<T: Publisher>(of publisher: T,
//                                     timeout: TimeInterval = 2,
//                                     file: StaticString = #file,
//                                     line: UInt = #line) -> CompetionResult {
//        let exp = expectation(description: "Failure completion of " + String(describing: publisher))
//
//        let cancellable = publisher
//            .sink(receiveCompletion: { completion in
//                if case .failure(_) = completion {
//                    exp.fulfill()
//                }
//            }, receiveValue: { _ in })
//
//        return (exp, cancellable)
//    }
//
//    func expectValue<T: Publisher>(of publisher: T,
//                                   timeout: TimeInterval = 2,
//                                   file: StaticString = #file,
//                                   line: UInt = #line,
//                                   equals: [(T.Output) -> Bool]) -> CompetionResult {
//        let exp = expectation(description: "Correct values of " + String(describing: publisher))
//        var mutableEquals = equals
//        let cancellable = publisher
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: { value in
//                if mutableEquals.first?(value) ?? false {
//                    _ = mutableEquals.remove(at: 0)
//                    if mutableEquals.isEmpty {
//                        exp.fulfill()
//                    }
//                }
//            })
//        return (exp, cancellable)
//    }
}
