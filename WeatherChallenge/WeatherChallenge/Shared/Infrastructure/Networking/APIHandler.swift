import Foundation

protocol APIHandlerProtocol {
    func makeDataTask(session: URLSession, request: URLRequest, completion: @escaping ((Data?, Error?)->()))
}

class APIHanndler: APIHandlerProtocol {
    
    private let logger: LoggerProtocol
    private let configuration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = false //false = return immediatly with error, true = need to handle connectivity status
        configuration.timeoutIntervalForRequest = 60
        return configuration
    }()
    
    init(logger: LoggerProtocol) {
        self.logger = logger
    }
    
    func makeDataTask(session: URLSession = .shared, request: URLRequest, completion: @escaping ((Data?, Error?)->())) {
        
        session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            
            self?.logger.logNetwork(data: data, response: response, error: error)
            if let error = error {
                completion(nil, error)
            } else if data != nil {
                completion(data!, nil)
            }
        }).resume()
    }
}
