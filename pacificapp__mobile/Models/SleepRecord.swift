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
    let priority: String
    let durationMinutes: Int
    let isQuick: Bool
    let type: Int
    let createdAt: String
    let updatedAt: String
    
    enum Category: String, Codable, CaseIterable {
        case sleep
        case stress
        case work
        case activity
        
        var displayTitle: String {
            switch self {
            case .sleep:
                return "Sleep"
            case .stress:
                return "Stress"
            case .work:
                return "Work"
            case .activity:
                return "Activity"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case priority
        case durationMinutes = "duration_minutes"
        case isQuick = "is_quick"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserRecommendation: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: Recommendation.Category
    let priority: String
    let durationMinutes: Int
    let isQuick: Bool
    let recommendationType: String
    let status: Status
    let reason: String?
    let userFeedback: String?
    let userRating: Int?
    let createdAt: String
    let completedAt: String?
    
    enum Status: String, Codable, CaseIterable {
        case new = "new"
        case inProgress = "in_progress"
        case completed = "completed"
        case skipped = "skipped"
        
        var displayTitle: String {
            switch self {
            case .new:
                return "New"
            case .inProgress:
                return "In Progress"
            case .completed:
                return "Completed"
            case .skipped:
                return "Skipped"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case priority
        case durationMinutes = "duration_minutes"
        case isQuick = "is_quick"
        case recommendationType = "recommendation_type"
        case status
        case reason
        case userFeedback = "user_feedback"
        case userRating = "user_rating"
        case createdAt = "created_at"
        case completedAt = "completed_at"
    }
}