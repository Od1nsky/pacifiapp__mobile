import Foundation

struct BurnoutRisk: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let date: String // YYYY-MM-DD
    let riskLevel: Int32 // 0-100
    let factors: [String: String]
    let recommendations: [String]
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case date
        case riskLevel = "risk_level"
        case factors
        case recommendations
        case createdAt = "created_at"
    }
}

struct FactorData: Codable {
    let overtimeFactor: String
    let workdayDurationFactor: String
    let stressFactor: String
    let sleepQualityFactor: String
    let sleepDeprivationFactor: String
    let factorsData: [String: String]
    let recommendations: [String]
    
    enum CodingKeys: String, CodingKey {
        case overtimeFactor = "overtime_factor"
        case workdayDurationFactor = "workday_duration_factor"
        case stressFactor = "stress_factor"
        case sleepQualityFactor = "sleep_quality_factor"
        case sleepDeprivationFactor = "sleep_deprivation_factor"
        case factorsData = "factors_data"
        case recommendations
    }
}

struct WeeklyData: Codable {
    let dailyData: [DailyRiskData]
    
    enum CodingKeys: String, CodingKey {
        case dailyData = "daily_data"
    }
}

struct DailyRiskData: Codable, Identifiable {
    let id = UUID()
    let date: String // YYYY-MM-DD
    let riskLevel: Int32 // 0-100
    
    enum CodingKeys: String, CodingKey {
        case date
        case riskLevel = "risk_level"
    }
}
