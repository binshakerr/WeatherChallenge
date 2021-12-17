import Foundation

protocol ParserProtocol {
    func convertDataTo<T: Decodable>(data: Data, type: T.Type) -> Result<T, Error>
}

class Parser: ParserProtocol {
    
    func convertDataTo<T: Decodable>(data: Data, type: T.Type) -> Result<T, Error> {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch let error {
            return .failure(error)
        }
    }
}
