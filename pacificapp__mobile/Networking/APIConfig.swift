import Foundation

enum APIConfig {
    static var baseURL: String {
        if let urlString = Bundle.main.infoDictionary?["API_BASE_URL"] as? String {
            return urlString
        }
        return "http://localhost:50051"
    }
}

