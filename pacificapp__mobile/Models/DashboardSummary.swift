import Foundation

struct DashboardSummary: Codable {
    let currentStressLevel: Double
    let averageSleepHours: Double
    let averageWorkHours: Double
    let burnoutRiskLevel: Int32 // 0-100
    let activeRecommendations: Int32
    let completedRecommendations: Int32
    let lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case currentStressLevel = "current_stress_level"
        case averageSleepHours = "average_sleep_hours"
        case averageWorkHours = "average_work_hours"
        case burnoutRiskLevel = "burnout_risk_level"
        case activeRecommendations = "active_recommendations"
        case completedRecommendations = "completed_recommendations"
        case lastUpdated = "last_updated"
    }
}
