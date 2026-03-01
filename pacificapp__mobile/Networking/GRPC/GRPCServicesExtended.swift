import Foundation
import GRPC
import SwiftProtobuf

// MARK: - Stress Service
final class StressGRPCService {
    private let client: Stress_StressServiceAsyncClient
    
    init(client: Stress_StressServiceAsyncClient) {
        self.client = client
    }
    
    func createStressLevel(level: Int32, notes: String?) async throws -> StressLevel {
        var request = Stress_CreateStressLevelRequest()
        request.level = level
        if let notes = notes { request.notes = notes }
        
        let call = client.makeCreateStressLevelCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return StressLevel(from: response.stressLevel)
    }
    
    func getStressLevel(id: Int64) async throws -> StressLevel {
        var request = Stress_GetStressLevelRequest()
        request.id = id
        
        let call = client.makeGetStressLevelCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return StressLevel(from: response.stressLevel)
    }
    
    func listStressLevels(
        page: Int32 = 1,
        pageSize: Int32 = 20,
        startDate: String?,
        endDate: String?
    ) async throws -> (levels: [StressLevel], pagination: PaginationInfo) {
        var request = Stress_ListStressLevelsRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        if let start = startDate, let end = endDate {
            request.dateRange.startDate = start
            request.dateRange.endDate = end
        }
        
        let call = client.makeListStressLevelsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            levels: response.stressLevels.map { StressLevel(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func updateStressLevel(id: Int64, level: Int32, notes: String?) async throws -> StressLevel {
        var request = Stress_UpdateStressLevelRequest()
        request.id = id
        request.level = level
        if let notes = notes { request.notes = notes }
        
        let call = client.makeUpdateStressLevelCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return StressLevel(from: response.stressLevel)
    }
    
    func deleteStressLevel(id: Int64) async throws -> Bool {
        var request = Stress_DeleteStressLevelRequest()
        request.id = id
        
        let call = client.makeDeleteStressLevelCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.success
    }
    
    func getStressStatistics(startDate: String, endDate: String) async throws -> StressStatistics {
        var request = Stress_GetStressStatisticsRequest()
        request.dateRange.startDate = startDate
        request.dateRange.endDate = endDate
        
        let call = client.makeGetStressStatisticsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return StressStatistics(from: response.statistics)
    }
}

// MARK: - Burnout Service
final class BurnoutGRPCService {
    private let client: Burnout_BurnoutRiskServiceAsyncClient
    
    init(client: Burnout_BurnoutRiskServiceAsyncClient) {
        self.client = client
    }
    
    func calculateBurnoutRisk() async throws -> BurnoutRisk {
        let request = Burnout_CalculateBurnoutRiskRequest()
        let call = client.makeCalculateBurnoutRiskCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return BurnoutRisk(from: response.burnoutRisk)
    }
    
    func calculateFactorData() async throws -> FactorData {
        let request = Burnout_CalculateFactorDataRequest()
        let call = client.makeCalculateFactorDataCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return FactorData(from: response.factorData)
    }
    
    func getBurnoutRiskHistory() async throws -> [BurnoutRisk] {
        let request = Burnout_GetBurnoutRiskHistoryRequest()
        let call = client.makeGetBurnoutRiskHistoryCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.history.map { BurnoutRisk(from: $0) }
    }
    
    func getLatestBurnoutRisk() async throws -> BurnoutRisk {
        let request = Burnout_GetLatestBurnoutRiskRequest()
        let call = client.makeGetLatestBurnoutRiskCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return BurnoutRisk(from: response.burnoutRisk)
    }
    
    func getWeeklyData() async throws -> WeeklyData {
        let request = Burnout_GetWeeklyDataRequest()
        let call = client.makeGetWeeklyDataCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return WeeklyData(from: response.weeklyData)
    }
    
    func getBurnoutRisk(id: Int64) async throws -> BurnoutRisk {
        var request = Burnout_GetBurnoutRiskRequest()
        request.id = id
        
        let call = client.makeGetBurnoutRiskCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return BurnoutRisk(from: response.burnoutRisk)
    }
    
    func listBurnoutRisks(page: Int32 = 1, pageSize: Int32 = 20) async throws -> (risks: [BurnoutRisk], pagination: PaginationInfo) {
        var request = Burnout_ListBurnoutRisksRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        let call = client.makeListBurnoutRisksCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            risks: response.burnoutRisks.map { BurnoutRisk(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
}

// MARK: - Recommendation Service
final class RecommendationGRPCService {
    private let client: Recommendation_RecommendationServiceAsyncClient
    
    init(client: Recommendation_RecommendationServiceAsyncClient) {
        self.client = client
    }
    
    func listRecommendations(
        page: Int32 = 1,
        pageSize: Int32 = 20,
        category: Recommendation_RecommendationCategory?,
        priority: Recommendation_RecommendationPriority?,
        isQuick: Bool?,
        type: Int32?
    ) async throws -> (recommendations: [Recommendation], pagination: PaginationInfo) {
        var request = Recommendation_ListRecommendationsRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        if let category = category { request.category = category }
        if let priority = priority { request.priority = priority }
        if let isQuick = isQuick { request.isQuick = isQuick }
        if let type = type { request.type = type }
        
        let call = client.makeListRecommendationsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            recommendations: response.recommendations.map { Recommendation(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func getRecommendation(id: Int64) async throws -> Recommendation {
        var request = Recommendation_GetRecommendationRequest()
        request.id = id
        
        let call = client.makeGetRecommendationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return Recommendation(from: response.recommendation)
    }
    
    func listUserRecommendations(page: Int32 = 1, pageSize: Int32 = 20) async throws -> (recommendations: [UserRecommendation], pagination: PaginationInfo) {
        var request = Recommendation_ListUserRecommendationsRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        let call = client.makeListUserRecommendationsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            recommendations: response.recommendations.map { UserRecommendation(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func createUserRecommendation(recommendationId: Int64, reason: String?) async throws -> UserRecommendation {
        var request = Recommendation_CreateUserRecommendationRequest()
        request.recommendationID = recommendationId
        if let reason = reason { request.reason = reason }
        
        let call = client.makeCreateUserRecommendationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return UserRecommendation(from: response.recommendation)
    }
    
    func getUserRecommendation(publicId: String) async throws -> UserRecommendation {
        var request = Recommendation_GetUserRecommendationRequest()
        request.publicID = publicId
        
        let call = client.makeGetUserRecommendationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return UserRecommendation(from: response.recommendation)
    }
    
    func updateUserRecommendation(
        publicId: String,
        status: Recommendation_RecommendationStatus?,
        userFeedback: String?,
        userRating: Int32?
    ) async throws -> UserRecommendation {
        var request = Recommendation_UpdateUserRecommendationRequest()
        request.publicID = publicId
        if let status = status { request.status = status }
        if let feedback = userFeedback { request.userFeedback = feedback }
        if let rating = userRating { request.userRating = rating }
        
        let call = client.makeUpdateUserRecommendationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return UserRecommendation(from: response.recommendation)
    }
    
    func updateRecommendationStatus(publicId: String, status: Recommendation_RecommendationStatus) async throws -> UserRecommendation {
        var request = Recommendation_UpdateRecommendationStatusRequest()
        request.publicID = publicId
        request.status = status
        
        let call = client.makeUpdateRecommendationStatusCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return UserRecommendation(from: response.recommendation)
    }
    
    func deleteUserRecommendation(publicId: String) async throws -> Bool {
        var request = Recommendation_DeleteUserRecommendationRequest()
        request.publicID = publicId
        
        let call = client.makeDeleteUserRecommendationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.success
    }
    
    func requestNewRecommendations() async throws -> [UserRecommendation] {
        let request = Recommendation_RequestNewRecommendationsRequest()
        let call = client.makeRequestNewRecommendationsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.recommendations.map { UserRecommendation(from: $0) }
    }
    
    func getRecommendationStats() async throws -> Recommendation_RecommendationStats {
        let request = Recommendation_GetRecommendationStatsRequest()
        let call = client.makeGetRecommendationStatsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.stats
    }
}

// MARK: - Calendar Service
final class CalendarGRPCService {
    private let client: Calendar_CalendarServiceAsyncClient
    
    init(client: Calendar_CalendarServiceAsyncClient) {
        self.client = client
    }
    
    func createCalendarIntegration(
        type: CalendarIntegration.CalendarType,
        accessToken: String,
        refreshToken: String,
        tokenExpiry: Date?
    ) async throws -> CalendarIntegration {
        var request = Calendar_CreateCalendarIntegrationRequest()
        let calendarType: Calendar_CalendarType
        switch type {
        case .google: calendarType = .google
        case .outlook: calendarType = .outlook
        case .unspecified: calendarType = .unspecified
        }
        request.type = calendarType
        request.accessToken = accessToken
        request.refreshToken = refreshToken
        if let expiry = tokenExpiry {
            var timestamp = SwiftProtobuf.Google_Protobuf_Timestamp()
            timestamp.seconds = Int64(expiry.timeIntervalSince1970)
            request.tokenExpiry = timestamp
        }
        
        let call = client.makeCreateCalendarIntegrationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return CalendarIntegration(from: response.integration)
    }
    
    func getCalendarIntegration(id: Int64) async throws -> CalendarIntegration {
        var request = Calendar_GetCalendarIntegrationRequest()
        request.id = id
        
        let call = client.makeGetCalendarIntegrationCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return CalendarIntegration(from: response.integration)
    }
    
    func listCalendarIntegrations(page: Int32 = 1, pageSize: Int32 = 20) async throws -> (integrations: [CalendarIntegration], pagination: PaginationInfo) {
        var request = Calendar_ListCalendarIntegrationsRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        let call = client.makeListCalendarIntegrationsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            integrations: response.integrations.map { CalendarIntegration(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func syncCalendar(id: Int64) async throws -> (success: Bool, eventsSynced: Int32) {
        var request = Calendar_SyncCalendarRequest()
        request.id = id
        
        let call = client.makeSyncCalendarCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return (success: response.success, eventsSynced: response.eventsSynced)
    }
    
    func getCalendarEvents(id: Int64, startDate: String, endDate: String) async throws -> [CalendarEvent] {
        var request = Calendar_GetCalendarEventsRequest()
        request.id = id
        request.dateRange.startDate = startDate
        request.dateRange.endDate = endDate
        
        let call = client.makeGetCalendarEventsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.events.map { CalendarEvent(from: $0) }
    }
}

// MARK: - Dashboard Service
final class DashboardGRPCService {
    private let client: Dashboard_DashboardServiceAsyncClient
    
    init(client: Dashboard_DashboardServiceAsyncClient) {
        self.client = client
    }
    
    func getDashboardSummary() async throws -> DashboardSummary {
        let request = Dashboard_GetDashboardSummaryRequest()
        let call = client.makeGetDashboardSummaryCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return DashboardSummary(from: response.summary)
    }
}
