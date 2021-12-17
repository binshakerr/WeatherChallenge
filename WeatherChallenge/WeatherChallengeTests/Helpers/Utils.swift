import Foundation

class Utils {
    enum MockResponseType: String {
        case searchResults = "SearchResults"
        case weatherDetails = "WeatherDetails"
        
        var sampleData: Data? {
            return jsonDataFromFile(self.rawValue)
        }
        
        func sampleDataFor(_ testClass: AnyObject) -> Data? {
            let bundle = Bundle(for: type(of: testClass))
            return jsonDataFromFile(self.rawValue, bundle: bundle)
        }
        
        func jsonDataFromFile(_ fileName: String, bundle: Bundle = Bundle.main) -> Data? {
            if let url = bundle.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    return data
                } catch let error {
                    print("error: \(error)")
                }
            }
            return nil
        }
    }
}
