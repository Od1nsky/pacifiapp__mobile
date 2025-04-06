import Foundation

struct WorkActivity: Codable, Identifiable {
    let id: Int
    let date: String
    let durationHours: Double
    let breaksCount: Int?
    let breaksTotalMinutes: Int?
    let productivity: Int?
    let notes: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case durationHours = "duration_hours"
        case breaksCount = "breaks_count"
        case breaksTotalMinutes = "breaks_total_minutes"
        case productivity
        case notes
        case createdAt = "created_at"
    }
}

struct WorkActivityCreate: Codable {
    let date: String
    let durationHours: Double
    let breaksCount: Int?
    let breaksTotalMinutes: Int?
    let productivity: Int?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case durationHours = "duration_hours"
        case breaksCount = "breaks_count"
        case breaksTotalMinutes = "breaks_total_minutes"
        case productivity
        case notes
    }
}

struct WorkStatistics: Codable {
    let averageDuration: Double
    let averageProductivity: Double?
    let averageBreaksCount: Double?
    let averageBreaksDuration: Double?
    let totalRecords: Int
    let startDate: String
    let endDate: String
    let dailyData: [DailyWorkData]
    
    enum CodingKeys: String, CodingKey {
        case averageDuration = "average_duration"
        case averageProductivity = "average_productivity"
        case averageBreaksCount = "average_breaks_count"
        case averageBreaksDuration = "average_breaks_duration"
        case totalRecords = "total_records"
        case startDate = "start_date"
        case endDate = "end_date"
        case dailyData = "daily_data"
    }
}

struct DailyWorkData: Codable, Identifiable {
    let id = UUID()
    let date: String
    let durationHours: Double
    let productivity: Double?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case durationHours = "duration_hours"
        case productivity
        case notes
    }
} 