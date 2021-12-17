
import Foundation

enum WeatherService {
    case searchCities(name: String)
}

extension WeatherService: EndPoint {
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchCities:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchCities:
            return "/search.json"
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
        }
        
    }
    
    var headers: [String: String] {
        return [:]
    }
    
}

//extension PlayListService {
//    func asURLRequest() throws -> URLRequest {
//        return try makeURLRequest()
//    }
//}
