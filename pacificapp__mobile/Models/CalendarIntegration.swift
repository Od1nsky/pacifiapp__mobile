import Foundation

struct CalendarIntegration: Codable, Identifiable {
    let id: Int64
    let userId: Int64
    let type: CalendarType
    let isActive: Bool
    let lastSync: String?
    let createdAt: String
    let updatedAt: String
    
    enum CalendarType: String, Codable {
        case google = "google"
        case outlook = "outlook"
        case unspecified = "unspecified"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case isActive = "is_active"
        case lastSync = "last_sync"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CalendarEvent: Codable, Identifiable {
    let id = UUID()
    let eventId: String
    let title: String
    let description: String
    let startTime: String
    let endTime: String
    let isAllDay: Bool
    let location: String?
    let isMeeting: Bool
    let attendeesCount: Int32
    let stressScore: Int32 // 0-100
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case title
        case description
        case startTime = "start_time"
        case endTime = "end_time"
        case isAllDay = "is_all_day"
        case location
        case isMeeting = "is_meeting"
        case attendeesCount = "attendees_count"
        case stressScore = "stress_score"
    }
}
