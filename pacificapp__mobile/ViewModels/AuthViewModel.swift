import Foundation
import GRPC

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let userService: UserGRPCService
    private let tokenStore: TokenStoring
    
    init(
        userService: UserGRPCService = GRPCServiceFactory.shared.userService,
        tokenStore: TokenStoring = TokenStore.shared
    ) {
        self.userService = userService
        self.tokenStore = tokenStore
        restoreSession()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await userService.login(email: email, password: password)
                tokenStore.save(accessToken: result.accessToken, refreshToken: result.refreshToken)
                currentUser = result.user
                isAuthenticated = true
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func signup(email: String, password: String, fullName: String) {
        isLoading = true
        errorMessage = nil
        
        // Разделяем fullName на firstName и lastName
        let nameComponents = fullName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.dropFirst().joined(separator: " ")
        
        // Генерируем username из email (до @)
        let username = email.components(separatedBy: "@").first ?? email
        
        Task {
            do {
                let result = try await userService.register(
                    username: username,
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName.isEmpty ? firstName : lastName,
                    dateOfBirth: nil
                )
                tokenStore.save(accessToken: result.accessToken, refreshToken: result.refreshToken)
                currentUser = result.user
                isAuthenticated = true
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func logout() {
        tokenStore.clear()
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
    }
    
    func refreshProfile() {
        fetchCurrentUser()
    }
    
    private func restoreSession() {
        guard tokenStore.accessToken != nil else { return }
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await userService.getCurrentUser()
                currentUser = user
                isAuthenticated = true
            } catch {
                // Если токен невалидный, выходим
                if let grpcError = error as? GRPCStatus, grpcError.code == .unauthenticated {
                    logout()
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
}
