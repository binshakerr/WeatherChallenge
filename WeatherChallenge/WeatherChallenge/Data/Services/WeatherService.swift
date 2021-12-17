
import Foundation

enum WeatherService {
    case searchCities(name: String)
    case currentWeather(name: String)
}

extension WeatherService: EndPoint {
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchCities:
            return .get
        case .currentWeather:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchCities:
            return "/search.json"
        case .currentWeather:
            return "/current.json"
        }
    }
    
    var parameters: [String: String] {
        switch self {
            
        case let .searchCities(name):
            let parameters = [
                "key": Environment.APIKey,
                "q": name
            ]
            return parameters
            
        case let .currentWeather(name):
            let parameters = [
                "key": Environment.APIKey,
                "q": name,
                "aqi": "no"
            ]
            return parameters
        }
    }
    
    var headers: [String: String] {
        return [:]
    }
    
}
