import Foundation
import SwiftUI

class WorkViewModel: ObservableObject {
    @Published var workActivities: [WorkActivity] = []
    @Published var workStatistics: WorkStatistics?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://localhost:8000/api"
    
    func fetchWorkActivities() {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/work-activity/") else {
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
                    let activities = try JSONDecoder().decode([WorkActivity].self, from: data)
                    self?.workActivities = activities
                } catch {
                    self?.errorMessage = "Failed to decode work activities"
                }
            }
        }.resume()
    }
    
    func fetchWorkStatistics(startDate: String, endDate: String) {
        isLoading = true
        var components = URLComponents(string: "\(baseURL)/work-activity/statistics/")!
        components.queryItems = [
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ]
        
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
                    let statistics = try JSONDecoder().decode(WorkStatistics.self, from: data)
                    self?.workStatistics = statistics
                } catch {
                    self?.errorMessage = "Failed to decode work statistics"
                }
            }
        }.resume()
    }
    
    func createWorkActivity(activity: WorkActivityCreate) {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/work-activity/") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(activity)
        } catch {
            errorMessage = "Failed to encode work activity"
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
                
                // Refresh the list after creating a new activity
                self?.fetchWorkActivities()
            }
        }.resume()
    }
} 