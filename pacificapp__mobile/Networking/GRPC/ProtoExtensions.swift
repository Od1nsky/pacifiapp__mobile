import Foundation
import SwiftProtobuf

// MARK: - User Extensions
extension User {
    init(from proto: User_User) {
        self.id = Int(proto.id)
        self.username = proto.username
        self.email = proto.email
        self.firstName = proto.firstName
        self.lastName = proto.lastName
        self.dateJoined = proto.hasDateJoined ? proto.dateJoined.asDateString() : nil
        self.lastLogin = proto.hasLastLogin ? proto.lastLogin.asDateString() : nil
        self.dateOfBirth = proto.dateOfBirth.isEmpty ? nil : proto.dateOfBirth
        self.avatar = proto.avatarURL.isEmpty ? nil : proto.avatarURL
        self.stressLevelBase = proto.stressLevelBase == 0 ? nil : Int(proto.stressLevelBase)
        self.sleepHoursAvg = proto.sleepHoursAvg == 0 ? nil : proto.sleepHoursAvg
        self.workHoursDaily = proto.workHoursDaily == 0 ? nil : proto.workHoursDaily
        self.notificationsEnabled = proto.notificationsEnabled
        self.notificationFrequency = proto.notificationFrequency == 0 ? nil : Int(proto.notificationFrequency)
    }
}

// MARK: - Sleep Record Extensions
extension SleepRecord {
    init(from proto: Sleep_SleepRecord) {
        self.id = Int(proto.id)
        self.date = proto.date
        self.durationHours = proto.durationHours
        self.quality = proto.quality == 0 ? nil : Int(proto.quality)
        self.notes = proto.notes.isEmpty ? nil : proto.notes
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
    }
}

// MARK: - Work Activity Extensions
extension WorkActivity {
    init(from proto: Work_WorkActivity) {
        self.id = Int(proto.id)
        self.date = proto.date
        self.durationHours = proto.durationHours
        self.breaksCount = proto.breaksCount == 0 ? nil : Int(proto.breaksCount)
        self.breaksTotalMinutes = proto.breaksTotalMinutes == 0 ? nil : Int(proto.breaksTotalMinutes)
        self.productivity = proto.productivity == 0 ? nil : Int(proto.productivity)
        self.notes = proto.notes.isEmpty ? nil : proto.notes
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
    }
}

// MARK: - Work Statistics Extensions
extension WorkStatistics {
    init(from proto: Work_WorkStatistics) {
        self.averageDuration = proto.averageDuration
        self.averageProductivity = proto.averageProductivity == 0 ? nil : proto.averageProductivity
        self.averageBreaksCount = proto.averageBreaksCount == 0 ? nil : Double(proto.averageBreaksCount)
        self.averageBreaksDuration = proto.averageBreaksDuration == 0 ? nil : Double(proto.averageBreaksDuration)
        self.totalRecords = Int(proto.totalRecords)
        self.startDate = proto.startDate
        self.endDate = proto.endDate
        self.dailyData = proto.dailyData.map { DailyWorkData(from: $0) }
    }
}

extension DailyWorkData {
    init(from proto: Work_DailyWorkData) {
        self.date = proto.date
        self.durationHours = proto.durationHours
        self.productivity = proto.productivity == 0 ? nil : proto.productivity
        self.notes = nil // Proto не содержит notes для daily data
    }
}

// MARK: - Sleep Statistics Extensions
struct SleepStatistics {
    let averageDuration: Double
    let averageQuality: Double?
    let totalRecords: Int
    let dailyData: [DailySleepData]
}

struct DailySleepData {
    let date: String
    let durationHours: Double
    let quality: Double?
}

extension SleepStatistics {
    init(from proto: Sleep_SleepStatistics) {
        self.averageDuration = proto.averageDuration
        self.averageQuality = proto.averageQuality == 0 ? nil : proto.averageQuality
        self.totalRecords = Int(proto.totalRecords)
        self.dailyData = proto.dailyData.map { DailySleepData(from: $0) }
    }
}

extension DailySleepData {
    init(from proto: Sleep_DailySleepData) {
        self.date = proto.date
        self.durationHours = proto.durationHours
        self.quality = proto.quality == 0 ? nil : proto.quality
    }
}

// MARK: - Stress Level Extensions
extension StressLevel {
    init(from proto: Stress_StressLevel) {
        self.id = proto.id
        self.userId = proto.userID
        self.level = proto.level
        self.notes = proto.notes.isEmpty ? nil : proto.notes
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
    }
}

extension StressStatistics {
    init(from proto: Stress_StressStatistics) {
        self.averageLevel = proto.averageLevel
        self.minLevel = proto.minLevel
        self.maxLevel = proto.maxLevel
        self.totalRecords = proto.totalRecords
        self.dailyData = proto.dailyData.map { DailyStressData(from: $0) }
    }
}

extension DailyStressData {
    init(from proto: Stress_DailyStressData) {
        self.date = proto.date
        self.averageLevel = proto.averageLevel
        self.count = proto.count
    }
}

// MARK: - Burnout Risk Extensions
extension BurnoutRisk {
    init(from proto: Burnout_BurnoutRisk) {
        self.id = proto.id
        self.userId = proto.userID
        self.date = proto.date
        self.riskLevel = proto.riskLevel
        self.factors = Dictionary(uniqueKeysWithValues: proto.factors.map { ($0.key, $0.value) })
        self.recommendations = proto.recommendations
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
    }
}

extension FactorData {
    init(from proto: Burnout_FactorData) {
        self.overtimeFactor = proto.overtimeFactor
        self.workdayDurationFactor = proto.workdayDurationFactor
        self.stressFactor = proto.stressFactor
        self.sleepQualityFactor = proto.sleepQualityFactor
        self.sleepDeprivationFactor = proto.sleepDeprivationFactor
        self.factorsData = Dictionary(uniqueKeysWithValues: proto.factorsData.map { ($0.key, $0.value) })
        self.recommendations = proto.recommendations
    }
}

extension WeeklyData {
    init(from proto: Burnout_WeeklyData) {
        self.dailyData = proto.dailyData.map { DailyRiskData(from: $0) }
    }
}

extension DailyRiskData {
    init(from proto: Burnout_DailyRiskData) {
        self.date = proto.date
        self.riskLevel = proto.riskLevel
    }
}

// MARK: - Calendar Integration Extensions
extension CalendarIntegration {
    init(from proto: Calendar_CalendarIntegration) {
        self.id = proto.id
        self.userId = proto.userID
        let calendarType: CalendarIntegration.CalendarType
        switch proto.type {
        case .google: calendarType = .google
        case .outlook: calendarType = .outlook
        default: calendarType = .unspecified
        }
        self.type = calendarType
        self.isActive = proto.isActive
        self.lastSync = proto.hasLastSync ? proto.lastSync.asDateString() : nil
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
        self.updatedAt = proto.hasUpdatedAt ? proto.updatedAt.asDateString() : ""
    }
}

extension CalendarEvent {
    init(from proto: Calendar_CalendarEvent) {
        self.eventId = proto.eventID
        self.title = proto.title
        self.description = proto.description_p
        self.startTime = proto.hasStartTime ? proto.startTime.asDateString() : ""
        self.endTime = proto.hasEndTime ? proto.endTime.asDateString() : ""
        self.isAllDay = proto.isAllDay
        self.location = proto.location.isEmpty ? nil : proto.location
        self.isMeeting = proto.isMeeting
        self.attendeesCount = proto.attendeesCount
        self.stressScore = proto.stressScore
    }
}

// MARK: - Dashboard Summary Extensions
extension DashboardSummary {
    init(from proto: Dashboard_DashboardSummary) {
        self.currentStressLevel = proto.currentStressLevel
        self.averageSleepHours = proto.averageSleepHours
        self.averageWorkHours = proto.averageWorkHours
        self.burnoutRiskLevel = proto.burnoutRiskLevel
        self.activeRecommendations = proto.activeRecommendations
        self.completedRecommendations = proto.completedRecommendations
        self.lastUpdated = proto.hasLastUpdated ? proto.lastUpdated.asDateString() : ""
    }
}

// MARK: - Pagination Extensions
extension PaginationInfo {
    init(from proto: Common_PaginationResponse) {
        self.count = proto.count
        self.page = proto.page
        self.pageSize = proto.pageSize
        self.totalPages = proto.totalPages
        self.hasNext = proto.hasNext_p
        self.hasPrevious = proto.hasPrevious_p
    }
    
    init(from proto: Burnout_PaginationResponse) {
        self.count = proto.count
        self.page = proto.page
        self.pageSize = proto.pageSize
        self.totalPages = proto.totalPages
        self.hasNext = proto.hasNext_p
        self.hasPrevious = proto.hasPrevious_p
    }
    
    init(from proto: Calendar_PaginationResponse) {
        self.count = proto.count
        self.page = proto.page
        self.pageSize = proto.pageSize
        self.totalPages = proto.totalPages
        self.hasNext = proto.hasNext_p
        self.hasPrevious = proto.hasPrevious_p
    }
}

// MARK: - Recommendation Extensions
extension Recommendation {
    init(from proto: Recommendation_Recommendation) {
        self.id = Int(proto.id)
        self.title = proto.title
        self.description = proto.description_p
        // Конвертация category из enum в String
        let categoryString: String
        switch proto.category {
        case .categorySleep: categoryString = "sleep"
        case .categoryStress: categoryString = "stress"
        case .categoryWork: categoryString = "work"
        case .categoryActivity: categoryString = "activity"
        default: categoryString = "activity"
        }
        self.category = Category(rawValue: categoryString) ?? .activity
        // Конвертация priority из enum в String
        let priorityString: String
        switch proto.priority {
        case .
            priorityLow: priorityString = "low"
        case .priorityMedium: priorityString = "medium"
        case .priorityHigh: priorityString = "high"
        default: priorityString = "medium"
        }
        self.priority = priorityString
        self.durationMinutes = Int(proto.durationMinutes)
        self.isQuick = proto.isQuick
        self.type = Int(proto.type)
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
        self.updatedAt = proto.hasUpdatedAt ? proto.updatedAt.asDateString() : ""
    }
}

extension UserRecommendation {
    init(from proto: Recommendation_UserRecommendation) {
        self.id = proto.id
        self.title = proto.title
        self.description = proto.description_p
        // Конвертация category из enum
        let categoryValue: Recommendation.Category
        switch proto.category {
        case .categorySleep: categoryValue = .sleep
        case .categoryStress: categoryValue = .stress
        case .categoryWork: categoryValue = .work
        case .categoryActivity: categoryValue = .activity
        default: categoryValue = .activity
        }
        self.category = categoryValue
        // Конвертация priority из enum в String
        let priorityString: String
        switch proto.priority {
        case .priorityLow: priorityString = "low"
        case .priorityMedium: priorityString = "medium"
        case .priorityHigh: priorityString = "high"
        default: priorityString = "medium"
        }
        self.priority = priorityString
        self.durationMinutes = Int(proto.durationMinutes)
        self.isQuick = proto.isQuick
        self.recommendationType = proto.recommendationType
        // Конвертация status из enum
        let statusValue: UserRecommendation.Status
        switch proto.status {
        case .statusNew: statusValue = .new
        case .statusInProgress: statusValue = .inProgress
        case .statusCompleted: statusValue = .completed
        case .statusSkipped: statusValue = .skipped
        default: statusValue = .new
        }
        self.status = statusValue
        self.reason = proto.reason.isEmpty ? nil : proto.reason
        self.userFeedback = proto.userFeedback.isEmpty ? nil : proto.userFeedback
        self.userRating = proto.userRating == 0 ? nil : Int(proto.userRating)
        self.createdAt = proto.hasCreatedAt ? proto.createdAt.asDateString() : ""
        self.completedAt = proto.hasCompletedAt ? proto.completedAt.asDateString() : nil
    }
}

// MARK: - Helper Extensions
extension SwiftProtobuf.Google_Protobuf_Timestamp {
    func asDateString() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self.seconds))
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
}
