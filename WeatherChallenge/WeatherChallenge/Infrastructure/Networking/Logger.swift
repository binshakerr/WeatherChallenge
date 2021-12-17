import Foundation

protocol LoggerProtocol {
    func logNetwork(data: Data?, response: URLResponse?, error: Error?)
}

class Logger: LoggerProtocol {
    
    func logNetwork(data: Data?, response: URLResponse?, error: Error?) {
        print("[LOG] api data: \(data)")
        
        print("[LOG] api error: \(error)")
        
        print("[LOG] api response: \(response)")
    }
}
