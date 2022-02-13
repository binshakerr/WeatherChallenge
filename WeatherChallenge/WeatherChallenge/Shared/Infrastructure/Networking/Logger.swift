import Foundation

protocol LoggerProtocol {
    func logNetwork(data: Data?, response: URLResponse?, error: Error?)
}

class Logger: LoggerProtocol {
    
    func logNetwork(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("[LOG] api error: \(error)")
        }
        if let response = response {
            print("[LOG] api response: \(response)")
        }
        if let data = data {
            print("[LOG] api data: \(data)")
        }
    }
}
