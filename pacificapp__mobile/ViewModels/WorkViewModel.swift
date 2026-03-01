import Foundation
import GRPC

@MainActor
final class WorkViewModel: ObservableObject {
    @Published var workActivities: [WorkActivity] = []
    @Published var workStatistics: WorkStatistics?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastActionMessage: String?

    private let workService: WorkGRPCService

    init(workService: WorkGRPCService = GRPCServiceFactory.shared.workService) {
        self.workService = workService
    }

    func fetchWorkActivities() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await workService.listWorkActivities(
                    page: 1,
                    pageSize: 50,
                    startDate: nil,
                    endDate: nil,
                    date: nil
                )
                workActivities = result.activities
            } catch {
                errorMessage = mapError(error)
            }
            isLoading = false
        }
    }

    func fetchWorkStatistics(startDate: String, endDate: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let stats = try await workService.getWorkStatistics(
                    startDate: startDate,
                    endDate: endDate
                )
                workStatistics = stats
            } catch {
                errorMessage = mapError(error)
            }
            isLoading = false
        }
    }

    func createWorkActivity(activity: WorkActivityCreate) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await workService.createWorkActivity(
                    date: activity.date,
                    durationHours: activity.durationHours,
                    breaksCount: activity.breaksCount.map { Int32($0) },
                    breaksTotalMinutes: activity.breaksTotalMinutes.map { Int32($0) },
                    productivity: activity.productivity.map { Int32($0) },
                    notes: activity.notes
                )
                lastActionMessage = "Рабочая активность сохранена"
                fetchWorkActivities()
            } catch {
                errorMessage = mapError(error)
                isLoading = false
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
