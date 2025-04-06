import Foundation

struct SleepRecord: Codable, Identifiable {
    let id: Int
    let date: String
    let durationHours: Double
    let quality: Int?
    let notes: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case durationHours = "duration_hours"
        case quality
        case notes
        case createdAt = "created_at"
    }
}

struct SleepRecordCreate: Codable {
    let date: String
    let durationHours: Double
    let quality: Int?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case durationHours = "duration_hours"
        case quality
        case notes
    }
}

struct Recommendation: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: Category
    let durationMinutes: Int?
    let isQuick: Bool
    let type: Int
    
    enum Category: String, Codable {
        case rest = "rest"
        case sleep = "sleep"
        case exercise = "exercise"
        case mindfulness = "mindfulness"
        case social = "social"
        case workBalance = "work_balance"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case durationMinutes = "duration_minutes"
        case isQuick = "is_quick"
        case type
    }
}

struct UserRecommendation: Codable, Identifiable {
    let id: Int
    let user: Int
    let recommendation: Recommendation
    let status: Status
    let reason: String?
    let userFeedback: String?
    let userRating: Int?
    let completedAt: String?
    
    enum Status: String, Codable {
        case pending = "pending"
        case accepted = "accepted"
        case completed = "completed"
        case rejected = "rejected"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case recommendation
        case status
        case reason
        case userFeedback = "user_feedback"
        case userRating = "user_rating"
        case completedAt = "completed_at"
    }
} 