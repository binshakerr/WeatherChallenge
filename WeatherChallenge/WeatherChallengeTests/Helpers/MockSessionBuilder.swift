import Foundation

class MockSessionBuilder {
    static func getMockSessionFor(_ data: Data) -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        MockURLProtocol.stubResponseData = data
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        return URLSession(configuration: configuration)
    }
}
