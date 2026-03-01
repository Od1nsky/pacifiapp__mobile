import SwiftUI
import AlertToast

struct RecommendationsView: View {
    @StateObject private var viewModel = RecommendationsViewModel()
    @State private var selectedCategory: Recommendation.Category?
    @State private var selectedStatus: UserRecommendation.Status?
    @State private var expandedRecommendationId: String?

    private var successToastBinding: Binding<Bool> {
        Binding(
            get: { viewModel.lastActionMessage != nil },
            set: { if !$0 { viewModel.lastActionMessage = nil } }
        )
    }

    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                categoriesSection

                Button {
                    viewModel.requestNewRecommendations()
                } label: {
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .font(.subheadline)
                        Text("Подобрать рекомендации")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoadingUserData)

                userRecommendationsSection
                templatesSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Рекомендации")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.requestNewRecommendations()
                } label: {
                    Image(systemName: "wand.and.stars")
                        .font(.subheadline)
                }
            }
        }
        .refreshable {
            viewModel.fetchUserRecommendations(status: selectedStatus)
            viewModel.fetchRecommendations(category: selectedCategory)
        }
        .toast(isPresenting: successToastBinding) {
            AlertToast(type: .complete(.green), title: viewModel.lastActionMessage)
        }
        .toast(isPresenting: errorToastBinding) {
            AlertToast(type: .error(.red), title: viewModel.errorMessage)
        }
        .onAppear {
            viewModel.fetchUserRecommendations()
            viewModel.fetchRecommendations()
        }
    }

    // MARK: - Categories

    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: "Все",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil,
                    color: .blue
                ) {
                    selectedCategory = nil
                    viewModel.fetchRecommendations(category: nil)
                }

                ForEach(Recommendation.Category.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.displayTitle,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                        viewModel.fetchRecommendations(category: selectedCategory)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - User Recommendations

    private var userRecommendationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Мои рекомендации")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    StatusChip(title: "Все", isSelected: selectedStatus == nil) {
                        selectedStatus = nil
                        viewModel.fetchUserRecommendations(status: nil)
                    }
                    ForEach(UserRecommendation.Status.allCases, id: \.self) { status in
                        StatusChip(
                            title: status.localizedTitle,
                            isSelected: selectedStatus == status
                        ) {
                            selectedStatus = selectedStatus == status ? nil : status
                            viewModel.fetchUserRecommendations(status: selectedStatus)
                        }
                    }
                }
            }

            if viewModel.isLoadingUserData {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, 20)
                    Spacer()
                }
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            } else if viewModel.userRecommendations.isEmpty {
                VStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("Нажмите ✦ чтобы получить рекомендации")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            } else {
                VStack(spacing: 1) {
                    ForEach(viewModel.userRecommendations) { rec in
                        UserRecCard(
                            recommendation: rec,
                            isExpanded: expandedRecommendationId == rec.id,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    expandedRecommendationId = expandedRecommendationId == rec.id ? nil : rec.id
                                }
                            },
                            onStatusChange: { status in
                                viewModel.updateRecommendationStatus(id: rec.id, status: status)
                            }
                        )
                    }
                }
                .cornerRadius(10)
            }
        }
    }

    // MARK: - Templates

    private var templatesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Идеи")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
            }
            .padding(.horizontal, 4)

            if viewModel.isLoadingTemplates {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, 20)
                    Spacer()
                }
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            } else if viewModel.recommendations.isEmpty {
                Text("Список пуст")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
            } else {
                VStack(spacing: 1) {
                    ForEach(viewModel.recommendations) { rec in
                        TemplateCard(recommendation: rec)
                    }
                }
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - Category Chip

private struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? color : Color(.tertiarySystemGroupedBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Status Chip

private struct StatusChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isSelected ? Color.accentColor : Color(.tertiarySystemGroupedBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - User Recommendation Card

private struct UserRecCard: View {
    let recommendation: UserRecommendation
    let isExpanded: Bool
    let onTap: () -> Void
    let onStatusChange: (UserRecommendation.Status) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(recommendation.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(isExpanded ? nil : 1)
                            .multilineTextAlignment(.leading)

                        HStack(spacing: 6) {
                            Text(recommendation.category.displayTitle)
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Text("·")
                                .foregroundColor(.secondary)

                            Label("\(recommendation.durationMinutes) мин", systemImage: "clock")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            if recommendation.isQuick {
                                Image(systemName: "bolt.fill")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }

                    Spacer()

                    PriorityBadge(priority: recommendation.priority)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()

                    Text(recommendation.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)

                    if let reason = recommendation.reason, !reason.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "lightbulb")
                                .font(.caption2)
                            Text(reason)
                                .font(.caption)
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                    }

                    if let rating = recommendation.userRating {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.horizontal, 12)
                    }

                    HStack(spacing: 6) {
                        ForEach(UserRecommendation.Status.allCases, id: \.self) { status in
                            Button {
                                onStatusChange(status)
                            } label: {
                                Text(status.localizedTitle)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(recommendation.status == status
                                                 ? statusColor(for: status)
                                                 : Color(.tertiarySystemGroupedBackground))
                                    .foregroundColor(recommendation.status == status ? .white : .primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
    }

    private var statusColor: Color {
        statusColor(for: recommendation.status)
    }

    private func statusColor(for status: UserRecommendation.Status) -> Color {
        switch status {
        case .new: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        case .skipped: return .gray
        }
    }
}

// MARK: - Priority Badge

private struct PriorityBadge: View {
    let priority: String

    var body: some View {
        Text(priority.prefix(1).uppercased())
            .font(.caption2)
            .fontWeight(.bold)
            .frame(width: 18, height: 18)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }

    private var color: Color {
        switch priority.lowercased() {
        case "high": return .red
        case "medium": return .orange
        default: return .green
        }
    }
}

// MARK: - Template Card

private struct TemplateCard: View {
    let recommendation: Recommendation

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: recommendation.category.icon)
                .font(.caption)
                .foregroundColor(recommendation.category.color)
                .frame(width: 28, height: 28)
                .background(recommendation.category.color.opacity(0.12))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text(recommendation.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                PriorityBadge(priority: recommendation.priority)

                if recommendation.isQuick {
                    Label("\(recommendation.durationMinutes)м", systemImage: "bolt.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                } else {
                    Text("\(recommendation.durationMinutes) мин")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Model Extensions

extension Recommendation.Category {
    var icon: String {
        switch self {
        case .sleep: return "moon.fill"
        case .stress: return "brain.head.profile"
        case .work: return "briefcase.fill"
        case .activity: return "figure.run"
        }
    }

    var color: Color {
        switch self {
        case .sleep: return .indigo
        case .stress: return .red
        case .work: return .blue
        case .activity: return .green
        }
    }
}

extension UserRecommendation.Status {
    var localizedTitle: String {
        switch self {
        case .new: return "Новая"
        case .inProgress: return "В работе"
        case .completed: return "Готово"
        case .skipped: return "Пропущена"
        }
    }
}
