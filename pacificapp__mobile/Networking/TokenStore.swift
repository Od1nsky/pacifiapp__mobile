import Foundation

protocol TokenStoring {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    func save(accessToken: String, refreshToken: String)
    func clear()
}

final class TokenStore: TokenStoring {
    static let shared = TokenStore()
    
    private let storage: UserDefaults
    private let accessKey = "pacificapp.auth.access"
    private let refreshKey = "pacificapp.auth.refresh"
    
    private init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
    var accessToken: String? {
        storage.string(forKey: accessKey)
    }
    
    var refreshToken: String? {
        storage.string(forKey: refreshKey)
    }
    
    func save(accessToken: String, refreshToken: String) {
        storage.set(accessToken, forKey: accessKey)
        storage.set(refreshToken, forKey: refreshKey)
    }
    
    func clear() {
        storage.removeObject(forKey: accessKey)
        storage.removeObject(forKey: refreshKey)
    }
}

