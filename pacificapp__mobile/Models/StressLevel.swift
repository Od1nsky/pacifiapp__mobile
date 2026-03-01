import Foundation

struct StressLevel: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let level: Int32 // 0-100
    let notes: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case level
        case notes
        case createdAt = "created_at"
    }
}

struct StressStatistics: Codable {
    let averageLevel: Double
    let minLevel: Int32
    let maxLevel: Int32
    let totalRecords: Int32
    let dailyData: [DailyStressData]
    
    enum CodingKeys: String, CodingKey {
        case averageLevel = "average_level"
        case minLevel = "min_level"
        case maxLevel = "max_level"
        case totalRecords = "total_records"
        case dailyData = "daily_data"
    }
}

struct DailyStressData: Codable, Identifiable {
    let id = UUID()
    let date: String
    let averageLevel: Double
    let count: Int32
    
    enum CodingKeys: String, CodingKey {
        case date
        case averageLevel = "average_level"
        case count
    }
}
