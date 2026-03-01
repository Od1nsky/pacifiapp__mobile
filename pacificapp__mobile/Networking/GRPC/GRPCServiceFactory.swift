import Foundation
import GRPC

final class GRPCServiceFactory {
    static let shared = GRPCServiceFactory()
    
    private let clientManager: GRPCClientManager
    
    private init(clientManager: GRPCClientManager = .shared) {
        self.clientManager = clientManager
    }
    
    // MARK: - Public Services
    var userService: UserGRPCService {
        UserGRPCService(client: clientManager.userService)
    }
    
    var sleepService: SleepGRPCService {
        SleepGRPCService(client: clientManager.sleepService)
    }
    
    var workService: WorkGRPCService {
        WorkGRPCService(client: clientManager.workService)
    }
    
    var stressService: StressGRPCService {
        StressGRPCService(client: clientManager.stressService)
    }
    
    var burnoutService: BurnoutGRPCService {
        BurnoutGRPCService(client: clientManager.burnoutService)
    }
    
    var recommendationService: RecommendationGRPCService {
        RecommendationGRPCService(client: clientManager.recommendationService)
    }
    
    var calendarService: CalendarGRPCService {
        CalendarGRPCService(client: clientManager.calendarService)
    }
    
    var dashboardService: DashboardGRPCService {
        DashboardGRPCService(client: clientManager.dashboardService)
    }
}
