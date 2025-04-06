import Foundation
import SwiftUI

class SleepViewModel: ObservableObject {
    @Published var sleepRecords: [SleepRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://localhost:8000/api"
    
    func fetchSleepRecords() {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/sleep/") else {
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
                    let records = try JSONDecoder().decode([SleepRecord].self, from: data)
                    self?.sleepRecords = records
                } catch {
                    self?.errorMessage = "Failed to decode sleep records"
                }
            }
        }.resume()
    }
    
    func createSleepRecord(record: SleepRecordCreate) {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/sleep/") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(record)
        } catch {
            errorMessage = "Failed to encode sleep record"
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
                
                // Refresh the list after creating a new record
                self?.fetchSleepRecords()
            }
        }.resume()
    }
} 