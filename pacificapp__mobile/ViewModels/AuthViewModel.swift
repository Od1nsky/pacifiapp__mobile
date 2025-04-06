import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    func login(email: String, password: String) {
        // TODO: Implement actual login logic
        // For now, we'll just simulate a successful login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.currentUser = User(id: "1", email: email, fullName: "Test User")
        }
    }
    
    func signup(email: String, password: String, fullName: String) {
        // TODO: Implement actual signup logic
        // For now, we'll just simulate a successful signup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.currentUser = User(id: "1", email: email, fullName: fullName)
        }
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
    }
} 