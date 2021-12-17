import Foundation

protocol NetworkHandlerProtocol {
    func requestData<T: Decodable>(session: URLSession, request: URLRequest, type: T.Type, completion: @escaping ((T?, Error?)->()))
}

class NetworkHandler: NetworkHandlerProtocol {
    
    private var apiHandler: APIHandlerProtocol
    private var logger: LoggerProtocol
    private var parser: ParserProtocol
    
    init(apiHandler: APIHandlerProtocol, logger: LoggerProtocol, parser: ParserProtocol) {
        self.apiHandler = apiHandler
        self.logger = logger
        self.parser = parser
    }
    
    func requestData<T: Decodable>(session: URLSession, request: URLRequest, type: T.Type, completion: @escaping ((T?, Error?)->())) {
        
        apiHandler.makeDataTask(session: session, request: request) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                let result = self.parser.convertDataTo(data: data, type: type)
                switch result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
