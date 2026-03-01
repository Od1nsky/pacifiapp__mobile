import Foundation
import GRPC

@MainActor
final class RecommendationsViewModel: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    @Published var userRecommendations: [UserRecommendation] = []
    @Published var isLoadingTemplates = false
    @Published var isLoadingUserData = false
    @Published var errorMessage: String?
    @Published var lastActionMessage: String?

    private let recommendationService: RecommendationGRPCService

    init(recommendationService: RecommendationGRPCService = GRPCServiceFactory.shared.recommendationService) {
        self.recommendationService = recommendationService
    }

    func fetchRecommendations(category: Recommendation.Category? = nil) {
        isLoadingTemplates = true
        errorMessage = nil

        Task {
            do {
                let grpcCategory: Recommendation_RecommendationCategory?
                if let category = category {
                    switch category {
                    case .sleep: grpcCategory = .categorySleep
                    case .stress: grpcCategory = .categoryStress
                    case .work: grpcCategory = .categoryWork
                    case .activity: grpcCategory = .categoryActivity
                    }
                } else {
                    grpcCategory = nil
                }

                let result = try await recommendationService.listRecommendations(
                    page: 1,
                    pageSize: 50,
                    category: grpcCategory,
                    priority: nil,
                    isQuick: nil,
                    type: nil
                )
                recommendations = result.recommendations
            } catch {
                errorMessage = mapError(error)
            }
            isLoadingTemplates = false
        }
    }

    func fetchUserRecommendations(status: UserRecommendation.Status? = nil) {
        isLoadingUserData = true
        errorMessage = nil

        Task {
            do {
                let result = try await recommendationService.listUserRecommendations(
                    page: 1,
                    pageSize: 50
                )
                if let status = status {
                    userRecommendations = result.recommendations.filter { $0.status == status }
                } else {
                    userRecommendations = result.recommendations
                }
            } catch {
                errorMessage = mapError(error)
            }
            isLoadingUserData = false
        }
    }

    func requestNewRecommendations() {
        isLoadingUserData = true
        errorMessage = nil

        Task {
            do {
                let newRecs = try await recommendationService.requestNewRecommendations()
                userRecommendations = newRecs
                lastActionMessage = "Подобраны новые рекомендации"
            } catch {
                errorMessage = mapError(error)
            }
            isLoadingUserData = false
        }
    }

    func updateRecommendationStatus(id: String, status: UserRecommendation.Status) {
        isLoadingUserData = true
        errorMessage = nil

        let grpcStatus: Recommendation_RecommendationStatus
        switch status {
        case .new: grpcStatus = .statusNew
        case .inProgress: grpcStatus = .statusInProgress
        case .completed: grpcStatus = .statusCompleted
        case .skipped: grpcStatus = .statusSkipped
        }

        Task {
            do {
                _ = try await recommendationService.updateRecommendationStatus(
                    publicId: id,
                    status: grpcStatus
                )
                lastActionMessage = "Статус обновлен"
                fetchUserRecommendations()
            } catch {
                errorMessage = mapError(error)
                isLoadingUserData = false
            }
        }
    }

    private func mapError(_ error: Error) -> String {
        if let grpcError = error as? GRPCStatus {
            return grpcError.message ?? "Ошибка сервера (\(grpcError.code))"
        }
        return error.localizedDescription
    }
}
