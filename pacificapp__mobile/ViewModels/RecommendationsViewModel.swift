import Foundation
import SwiftUI

class RecommendationsViewModel: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    @Published var userRecommendations: [UserRecommendation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://localhost:8000/api"
    
    func fetchRecommendations(category: Recommendation.Category? = nil) {
        isLoading = true
        var components = URLComponents(string: "\(baseURL)/recommendations/")!
        
        if let category = category {
            components.queryItems = [
                URLQueryItem(name: "category", value: category.rawValue)
            ]
        }
        
        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    self?.recommendations = response.results
                } catch {
                    self?.errorMessage = "Failed to decode recommendations"
                }
            }
        }.resume()
    }
    
    func fetchUserRecommendations() {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/user-recommendations/") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(UserRecommendationsResponse.self, from: data)
                    self?.userRecommendations = response.results
                } catch {
                    self?.errorMessage = "Failed to decode user recommendations"
                }
            }
        }.resume()
    }
    
    func updateRecommendationStatus(id: Int, status: UserRecommendation.Status) {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/user-recommendations/\(id)/update_status/") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["status": status.rawValue]
        
        do {
            request.httpBody = try JSONEncoder().encode(updateData)
        } catch {
            errorMessage = "Failed to encode status update"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                // Refresh user recommendations after update
                self?.fetchUserRecommendations()
            }
        }.resume()
    }
}

struct RecommendationsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Recommendation]
}

struct UserRecommendationsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [UserRecommendation]
} 