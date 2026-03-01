import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let dateJoined: String?
    let lastLogin: String?
    let dateOfBirth: String?
    let avatar: String?
    let stressLevelBase: Int?
    let sleepHoursAvg: Double?
    let workHoursDaily: Double?
    let notificationsEnabled: Bool?
    let notificationFrequency: Int?
    
    var fullName: String {
        let components = [firstName, lastName].filter { !$0.isEmpty }
        if components.isEmpty {
            return email
        }
        return components.joined(separator: " ")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case dateJoined = "date_joined"
        case lastLogin = "last_login"
        case dateOfBirth = "date_of_birth"
        case avatar
        case stressLevelBase = "stress_level_base"
        case sleepHoursAvg = "sleep_hours_avg"
        case workHoursDaily = "work_hours_daily"
        case notificationsEnabled = "notifications_enabled"
        case notificationFrequency = "notification_frequency"
    }
}

struct UserProfileResponse: Codable {
    let id: Int
    let user: User
    let preferredRelaxationMethods: [String]
    let workStartTime: String?
    let workEndTime: String?
    let googleCalendarConnected: Bool
    let outlookConnected: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case preferredRelaxationMethods = "preferred_relaxation_methods"
        case workStartTime = "work_start_time"
        case workEndTime = "work_end_time"
        case googleCalendarConnected = "google_calendar_connected"
        case outlookConnected = "outlook_connected"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}