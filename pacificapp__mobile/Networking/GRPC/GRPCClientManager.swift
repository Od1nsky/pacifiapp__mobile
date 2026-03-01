import Foundation
import GRPC

final class GRPCClientManager {
    static let shared = GRPCClientManager()
    
    private var channel: GRPCChannel?
    private let tokenStore: TokenStoring
    
    private init(tokenStore: TokenStoring = TokenStore.shared) {
        self.tokenStore = tokenStore
        setupChannel()
    }
    
    private func setupChannel() {
        do {
            channel = try GRPCConfig.createChannel()
        } catch {
            print("❌ Failed to create gRPC channel: \(error)")
        }
    }
    
    func getChannel() -> GRPCChannel? {
        return channel
    }
    
    func createCallOptions() -> CallOptions {
        var options = CallOptions()
        
        if let token = tokenStore.accessToken {
            options.customMetadata.add(name: "authorization", value: "Bearer \(token)")
        }
        
        return options
    }
    
    func createCallOptions(requiresAuth: Bool) -> CallOptions {
        if requiresAuth {
            return createCallOptions()
        }
        return CallOptions()
    }
    
    // MARK: - Service Clients
    lazy var userService: User_UserServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return User_UserServiceAsyncClient(channel: channel)
    }()
    
    lazy var sleepService: Sleep_SleepServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Sleep_SleepServiceAsyncClient(channel: channel)
    }()
    
    lazy var workService: Work_WorkServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Work_WorkServiceAsyncClient(channel: channel)
    }()
    
    lazy var stressService: Stress_StressServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Stress_StressServiceAsyncClient(channel: channel)
    }()
    
    lazy var burnoutService: Burnout_BurnoutRiskServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Burnout_BurnoutRiskServiceAsyncClient(channel: channel)
    }()
    
    lazy var recommendationService: Recommendation_RecommendationServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Recommendation_RecommendationServiceAsyncClient(channel: channel)
    }()
    
    lazy var calendarService: Calendar_CalendarServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Calendar_CalendarServiceAsyncClient(channel: channel)
    }()
    
    lazy var dashboardService: Dashboard_DashboardServiceAsyncClient = {
        guard let channel = channel else {
            fatalError("gRPC channel not initialized")
        }
        return Dashboard_DashboardServiceAsyncClient(channel: channel)
    }()
}
