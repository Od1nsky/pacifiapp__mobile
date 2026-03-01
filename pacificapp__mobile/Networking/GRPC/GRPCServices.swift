import Foundation
import GRPC

// Импорт сгенерированных типов
// После добавления файлов в Xcode, раскомментируйте:
// import struct User_User
// import struct User_RegisterRequest
// и т.д.

// MARK: - User Service (Authentication)
final class UserGRPCService {
    private let client: User_UserServiceAsyncClient
    
    init(client: User_UserServiceAsyncClient) {
        self.client = client
    }
    
    func register(
        username: String,
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        dateOfBirth: String?
    ) async throws -> (user: User, accessToken: String, refreshToken: String) {
        var request = User_RegisterRequest()
        request.username = username
        request.email = email
        request.password = password
        request.firstName = firstName
        request.lastName = lastName
        if let dob = dateOfBirth {
            request.dateOfBirth = dob
        }
        
        let call = client.makeRegisterCall(request, callOptions: GRPCClientManager.shared.createCallOptions(requiresAuth: false))
        let response = try await call.response
        
        return (
            user: User(from: response.user),
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    func login(email: String, password: String) async throws -> (user: User, accessToken: String, refreshToken: String) {
        var request = User_LoginRequest()
        request.email = email
        request.password = password
        
        let call = client.makeLoginCall(request, callOptions: GRPCClientManager.shared.createCallOptions(requiresAuth: false))
        let response = try await call.response
        
        return (
            user: User(from: response.user),
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    func refreshToken(refreshToken: String) async throws -> (accessToken: String, refreshToken: String) {
        var request = User_RefreshTokenRequest()
        request.refreshToken = refreshToken
        
        let call = client.makeRefreshTokenCall(request, callOptions: GRPCClientManager.shared.createCallOptions(requiresAuth: false))
        let response = try await call.response
        
        return (
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    func getCurrentUser() async throws -> User {
        let request = User_GetCurrentUserRequest()
        let call = client.makeGetCurrentUserCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return User(from: response.user)
    }
    
    func updateProfile(
        firstName: String?,
        lastName: String?,
        dateOfBirth: String?,
        stressLevelBase: Int32?,
        sleepHoursAvg: Double?,
        workHoursDaily: Double?,
        notificationsEnabled: Bool?,
        notificationFrequency: Int32?
    ) async throws -> User {
        var request = User_UpdateProfileRequest()
        if let firstName = firstName { request.firstName = firstName }
        if let lastName = lastName { request.lastName = lastName }
        if let dob = dateOfBirth { request.dateOfBirth = dob }
        if let stress = stressLevelBase { request.stressLevelBase = stress }
        if let sleep = sleepHoursAvg { request.sleepHoursAvg = sleep }
        if let work = workHoursDaily { request.workHoursDaily = work }
        if let enabled = notificationsEnabled { request.notificationsEnabled = enabled }
        if let frequency = notificationFrequency { request.notificationFrequency = frequency }
        
        let call = client.makeUpdateProfileCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return User(from: response.user)
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws -> Bool {
        var request = User_ChangePasswordRequest()
        request.currentPassword = currentPassword
        request.newPassword = newPassword
        
        let call = client.makeChangePasswordCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.success
    }
}

// MARK: - Sleep Service
final class SleepGRPCService {
    private let client: Sleep_SleepServiceAsyncClient
    
    init(client: Sleep_SleepServiceAsyncClient) {
        self.client = client
    }
    
    func createSleepRecord(
        date: String,
        durationHours: Double,
        quality: Int32?,
        notes: String?
    ) async throws -> SleepRecord {
        var request = Sleep_CreateSleepRecordRequest()
        request.date = date
        request.durationHours = durationHours
        if let quality = quality { request.quality = quality }
        if let notes = notes { request.notes = notes }
        
        let call = client.makeCreateSleepRecordCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return SleepRecord(from: response.sleepRecord)
    }
    
    func getSleepRecord(id: Int64) async throws -> SleepRecord {
        var request = Sleep_GetSleepRecordRequest()
        request.id = id
        
        let call = client.makeGetSleepRecordCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return SleepRecord(from: response.sleepRecord)
    }
    
    func listSleepRecords(
        page: Int32 = 1,
        pageSize: Int32 = 20,
        startDate: String?,
        endDate: String?
    ) async throws -> (records: [SleepRecord], pagination: PaginationInfo) {
        var request = Sleep_ListSleepRecordsRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        if let start = startDate, let end = endDate {
            request.dateRange.startDate = start
            request.dateRange.endDate = end
        }
        
        let call = client.makeListSleepRecordsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            records: response.sleepRecords.map { SleepRecord(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func updateSleepRecord(
        id: Int64,
        date: String?,
        durationHours: Double?,
        quality: Int32?,
        notes: String?
    ) async throws -> SleepRecord {
        var request = Sleep_UpdateSleepRecordRequest()
        request.id = id
        if let date = date { request.date = date }
        if let duration = durationHours { request.durationHours = duration }
        if let quality = quality { request.quality = quality }
        if let notes = notes { request.notes = notes }
        
        let call = client.makeUpdateSleepRecordCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return SleepRecord(from: response.sleepRecord)
    }
    
    func deleteSleepRecord(id: Int64) async throws -> Bool {
        var request = Sleep_DeleteSleepRecordRequest()
        request.id = id
        
        let call = client.makeDeleteSleepRecordCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.success
    }
    
    func getSleepStatistics(startDate: String, endDate: String) async throws -> SleepStatistics {
        var request = Sleep_GetSleepStatisticsRequest()
        request.dateRange.startDate = startDate
        request.dateRange.endDate = endDate
        
        let call = client.makeGetSleepStatisticsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return SleepStatistics(from: response.statistics)
    }
}

// MARK: - Work Service
final class WorkGRPCService {
    private let client: Work_WorkServiceAsyncClient
    
    init(client: Work_WorkServiceAsyncClient) {
        self.client = client
    }
    
    func createWorkActivity(
        date: String,
        durationHours: Double,
        breaksCount: Int32?,
        breaksTotalMinutes: Int32?,
        productivity: Int32?,
        notes: String?
    ) async throws -> WorkActivity {
        var request = Work_CreateWorkActivityRequest()
        request.date = date
        request.durationHours = durationHours
        if let breaks = breaksCount { request.breaksCount = breaks }
        if let breaksMinutes = breaksTotalMinutes { request.breaksTotalMinutes = breaksMinutes }
        if let prod = productivity { request.productivity = prod }
        if let notes = notes { request.notes = notes }
        
        let call = client.makeCreateWorkActivityCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return WorkActivity(from: response.workActivity)
    }
    
    func getWorkActivity(id: Int64) async throws -> WorkActivity {
        var request = Work_GetWorkActivityRequest()
        request.id = id
        
        let call = client.makeGetWorkActivityCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return WorkActivity(from: response.workActivity)
    }
    
    func listWorkActivities(
        page: Int32 = 1,
        pageSize: Int32 = 20,
        startDate: String?,
        endDate: String?,
        date: String?
    ) async throws -> (activities: [WorkActivity], pagination: PaginationInfo) {
        var request = Work_ListWorkActivitiesRequest()
        request.pagination.page = page
        request.pagination.pageSize = pageSize
        
        if let start = startDate, let end = endDate {
            request.dateRange.startDate = start
            request.dateRange.endDate = end
        }
        if let date = date { request.date = date }
        
        let call = client.makeListWorkActivitiesCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        
        return (
            activities: response.workActivities.map { WorkActivity(from: $0) },
            pagination: PaginationInfo(from: response.pagination)
        )
    }
    
    func updateWorkActivity(
        id: Int64,
        date: String?,
        durationHours: Double?,
        breaksCount: Int32?,
        breaksTotalMinutes: Int32?,
        productivity: Int32?,
        notes: String?
    ) async throws -> WorkActivity {
        var request = Work_UpdateWorkActivityRequest()
        request.id = id
        if let date = date { request.date = date }
        if let duration = durationHours { request.durationHours = duration }
        if let breaks = breaksCount { request.breaksCount = breaks }
        if let breaksMinutes = breaksTotalMinutes { request.breaksTotalMinutes = breaksMinutes }
        if let prod = productivity { request.productivity = prod }
        if let notes = notes { request.notes = notes }
        
        let call = client.makeUpdateWorkActivityCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return WorkActivity(from: response.workActivity)
    }
    
    func deleteWorkActivity(id: Int64) async throws -> Bool {
        var request = Work_DeleteWorkActivityRequest()
        request.id = id
        
        let call = client.makeDeleteWorkActivityCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return response.success
    }
    
    func getWorkStatistics(startDate: String, endDate: String) async throws -> WorkStatistics {
        var request = Work_GetWorkStatisticsRequest()
        request.dateRange.startDate = startDate
        request.dateRange.endDate = endDate
        
        let call = client.makeGetWorkStatisticsCall(request, callOptions: GRPCClientManager.shared.createCallOptions())
        let response = try await call.response
        return WorkStatistics(from: response.statistics)
    }
}

// MARK: - Helper Types
// PaginationInfo moved to Models/PaginationInfo.swift
