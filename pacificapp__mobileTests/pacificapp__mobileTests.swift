//
//  pacificapp__mobileTests.swift
//  pacificapp__mobileTests
//
//  Created by Vladislav Kapustian on 13.03.2025.
//

import Testing
import Foundation
@testable import pacificapp__mobile

// MARK: - BurnoutRisk Tests

struct BurnoutRiskTests {

    @Test func burnoutRiskDecodingFromJSON() throws {
        let json = """
        {
            "id": 1,
            "user_id": 42,
            "date": "2025-01-15",
            "risk_level": 65,
            "factors": {
                "overtime_factor": "high",
                "stress_factor": "medium"
            },
            "recommendations": ["Take a break", "Meditate"],
            "created_at": "2025-01-15T10:00:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let risk = try decoder.decode(BurnoutRisk.self, from: json)

        #expect(risk.id == 1)
        #expect(risk.userId == 42)
        #expect(risk.date == "2025-01-15")
        #expect(risk.riskLevel == 65)
        #expect(risk.factors["overtime_factor"] == "high")
        #expect(risk.factors["stress_factor"] == "medium")
        #expect(risk.recommendations.count == 2)
        #expect(risk.recommendations[0] == "Take a break")
    }

    @Test func burnoutRiskEncodingToJSON() throws {
        let risk = BurnoutRisk(
            id: 1,
            userId: 42,
            date: "2025-01-15",
            riskLevel: 65,
            factors: ["overtime_factor": "high"],
            recommendations: ["Take a break"],
            createdAt: "2025-01-15T10:00:00Z"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(risk)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        #expect(json["id"] as? Int == 1)
        #expect(json["risk_level"] as? Int == 65)
    }
}

// MARK: - FactorData Tests

struct FactorDataTests {

    @Test func factorDataDecodingFromJSON() throws {
        let json = """
        {
            "overtime_factor": "high",
            "workday_duration_factor": "medium",
            "stress_factor": "low",
            "sleep_quality_factor": "high",
            "sleep_deprivation_factor": "medium",
            "factors_data": {"avg_work": "9.5"},
            "recommendations": ["Rest more"]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let factorData = try decoder.decode(FactorData.self, from: json)

        #expect(factorData.overtimeFactor == "high")
        #expect(factorData.workdayDurationFactor == "medium")
        #expect(factorData.stressFactor == "low")
        #expect(factorData.sleepQualityFactor == "high")
        #expect(factorData.sleepDeprivationFactor == "medium")
        #expect(factorData.factorsData["avg_work"] == "9.5")
        #expect(factorData.recommendations.count == 1)
    }
}

// MARK: - WeeklyData Tests

struct WeeklyDataTests {

    @Test func weeklyDataDecodingFromJSON() throws {
        let json = """
        {
            "daily_data": [
                {"date": "2025-01-15", "risk_level": 45},
                {"date": "2025-01-14", "risk_level": 50}
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let weeklyData = try decoder.decode(WeeklyData.self, from: json)

        #expect(weeklyData.dailyData.count == 2)
        #expect(weeklyData.dailyData[0].date == "2025-01-15")
        #expect(weeklyData.dailyData[0].riskLevel == 45)
    }
}

// MARK: - SleepRecord Tests

struct SleepRecordTests {

    @Test func sleepRecordDecodingFromJSON() throws {
        let json = """
        {
            "id": 1,
            "date": "2025-01-15",
            "duration_hours": 7.5,
            "quality": 8,
            "notes": "Good sleep",
            "created_at": "2025-01-15T08:00:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let record = try decoder.decode(SleepRecord.self, from: json)

        #expect(record.id == 1)
        #expect(record.date == "2025-01-15")
        #expect(record.durationHours == 7.5)
        #expect(record.quality == 8)
        #expect(record.notes == "Good sleep")
    }

    @Test func sleepRecordWithNullQuality() throws {
        let json = """
        {
            "id": 1,
            "date": "2025-01-15",
            "duration_hours": 6.0,
            "quality": null,
            "notes": null,
            "created_at": "2025-01-15T08:00:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let record = try decoder.decode(SleepRecord.self, from: json)

        #expect(record.quality == nil)
        #expect(record.notes == nil)
    }
}

// MARK: - Recommendation Tests

struct RecommendationTests {

    @Test func recommendationCategoryDisplayTitles() {
        #expect(Recommendation.Category.sleep.displayTitle == "Sleep")
        #expect(Recommendation.Category.stress.displayTitle == "Stress")
        #expect(Recommendation.Category.work.displayTitle == "Work")
        #expect(Recommendation.Category.activity.displayTitle == "Activity")
    }

    @Test func recommendationCategoryAllCases() {
        let allCases = Recommendation.Category.allCases
        #expect(allCases.count == 4)
        #expect(allCases.contains(.sleep))
        #expect(allCases.contains(.stress))
        #expect(allCases.contains(.work))
        #expect(allCases.contains(.activity))
    }
}

// MARK: - UserRecommendation Tests

struct UserRecommendationTests {

    @Test func userRecommendationStatusDisplayTitles() {
        #expect(UserRecommendation.Status.new.displayTitle == "New")
        #expect(UserRecommendation.Status.inProgress.displayTitle == "In Progress")
        #expect(UserRecommendation.Status.completed.displayTitle == "Completed")
        #expect(UserRecommendation.Status.skipped.displayTitle == "Skipped")
    }

    @Test func userRecommendationStatusAllCases() {
        let allCases = UserRecommendation.Status.allCases
        #expect(allCases.count == 4)
    }

    @Test func userRecommendationDecodingFromJSON() throws {
        let json = """
        {
            "id": "uuid-123",
            "title": "Morning Meditation",
            "description": "Start your day with meditation",
            "category": "stress",
            "priority": "high",
            "duration_minutes": 10,
            "is_quick": true,
            "recommendation_type": "relaxation",
            "status": "new",
            "reason": "High stress detected",
            "user_feedback": null,
            "user_rating": null,
            "created_at": "2025-01-15T08:00:00Z",
            "completed_at": null
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let rec = try decoder.decode(UserRecommendation.self, from: json)

        #expect(rec.id == "uuid-123")
        #expect(rec.title == "Morning Meditation")
        #expect(rec.category == .stress)
        #expect(rec.status == .new)
        #expect(rec.isQuick == true)
        #expect(rec.durationMinutes == 10)
    }
}

// MARK: - SleepRecordCreate Tests

struct SleepRecordCreateTests {

    @Test func sleepRecordCreateEncodingToJSON() throws {
        let record = SleepRecordCreate(
            date: "2025-01-15",
            durationHours: 7.5,
            quality: 8,
            notes: "Good sleep"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(record)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        #expect(json["date"] as? String == "2025-01-15")
        #expect(json["duration_hours"] as? Double == 7.5)
        #expect(json["quality"] as? Int == 8)
        #expect(json["notes"] as? String == "Good sleep")
    }

    @Test func sleepRecordCreateWithNilValues() throws {
        let record = SleepRecordCreate(
            date: "2025-01-15",
            durationHours: 6.0,
            quality: nil,
            notes: nil
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(record)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        #expect(json["quality"] == nil || json["quality"] is NSNull)
    }
}

// MARK: - DailyRiskData Tests

struct DailyRiskDataTests {

    @Test func dailyRiskDataIdentifiable() throws {
        let data1 = DailyRiskData(date: "2025-01-15", riskLevel: 50)
        let data2 = DailyRiskData(date: "2025-01-15", riskLevel: 50)

        // Each instance should have a unique ID
        #expect(data1.id != data2.id)
    }

    @Test func dailyRiskDataDecoding() throws {
        let json = """
        {
            "date": "2025-01-15",
            "risk_level": 55
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let data = try decoder.decode(DailyRiskData.self, from: json)

        #expect(data.date == "2025-01-15")
        #expect(data.riskLevel == 55)
    }
}
