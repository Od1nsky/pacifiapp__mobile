import SwiftUI

struct RecommendationsView: View {
    @StateObject private var recommendationsViewModel = RecommendationsViewModel()
    @State private var selectedCategory: Recommendation.Category?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Categories")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Recommendation.Category.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: {
                                        selectedCategory = selectedCategory == category ? nil : category
                                        recommendationsViewModel.fetchRecommendations(category: selectedCategory)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Section(header: Text("Your Recommendations")) {
                    if recommendationsViewModel.isLoading {
                        ProgressView()
                    } else if recommendationsViewModel.userRecommendations.isEmpty {
                        Text("No recommendations yet")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(recommendationsViewModel.userRecommendations) { userRecommendation in
                            UserRecommendationRow(
                                recommendation: userRecommendation,
                                onStatusChange: { newStatus in
                                    recommendationsViewModel.updateRecommendationStatus(
                                        id: userRecommendation.id,
                                        status: newStatus
                                    )
                                }
                            )
                        }
                    }
                }
                
                Section(header: Text("Available Recommendations")) {
                    if recommendationsViewModel.isLoading {
                        ProgressView()
                    } else if recommendationsViewModel.recommendations.isEmpty {
                        Text("No recommendations available")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(recommendationsViewModel.recommendations) { recommendation in
                            RecommendationRow(recommendation: recommendation)
                        }
                    }
                }
            }
            .navigationTitle("Recommendations")
            .onAppear {
                recommendationsViewModel.fetchUserRecommendations()
                recommendationsViewModel.fetchRecommendations()
            }
        }
    }
}

struct CategoryButton: View {
    let category: Recommendation.Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue.capitalized)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

struct RecommendationRow: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recommendation.title)
                .font(.headline)
            
            Text(recommendation.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                if let duration = recommendation.durationMinutes {
                    Label("\(duration) min", systemImage: "clock")
                }
                
                if recommendation.isQuick {
                    Label("Quick", systemImage: "bolt")
                }
                
                Spacer()
                
                Text(recommendation.category.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct UserRecommendationRow: View {
    let recommendation: UserRecommendation
    let onStatusChange: (UserRecommendation.Status) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recommendation.recommendation.title)
                .font(.headline)
            
            Text(recommendation.recommendation.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                if let duration = recommendation.recommendation.durationMinutes {
                    Label("\(duration) min", systemImage: "clock")
                }
                
                if recommendation.recommendation.isQuick {
                    Label("Quick", systemImage: "bolt")
                }
                
                Spacer()
                
                Menu {
                    ForEach(UserRecommendation.Status.allCases, id: \.self) { status in
                        Button(status.rawValue.capitalized) {
                            onStatusChange(status)
                        }
                    }
                } label: {
                    Text(recommendation.status.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(for: recommendation.status))
                        .cornerRadius(4)
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            if let feedback = recommendation.userFeedback {
                Text("Feedback: \(feedback)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let rating = recommendation.userRating {
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func statusColor(for status: UserRecommendation.Status) -> Color {
        switch status {
        case .pending:
            return .gray.opacity(0.2)
        case .accepted:
            return .blue.opacity(0.2)
        case .completed:
            return .green.opacity(0.2)
        case .rejected:
            return .red.opacity(0.2)
        }
    }
}

extension Recommendation.Category: CaseIterable {
    static var allCases: [Recommendation.Category] = [
        .rest,
        .sleep,
        .exercise,
        .mindfulness,
        .social,
        .workBalance
    ]
}

extension UserRecommendation.Status: CaseIterable {
    static var allCases: [UserRecommendation.Status] = [
        .pending,
        .accepted,
        .completed,
        .rejected
    ]
} 