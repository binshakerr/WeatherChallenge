import Foundation

protocol EndPoint {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var headers: [String: String] { get }
}

extension EndPoint {
    
    func makeURLRequest() throws -> URLRequest {
        let fullURLString = baseURL + path
        var components = URLComponents(string: fullURLString)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        return request
    }
}
