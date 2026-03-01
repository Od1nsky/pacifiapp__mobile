import Foundation
import GRPC

@MainActor
final class SleepViewModel: ObservableObject {
    @Published var sleepRecords: [SleepRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastActionMessage: String?

    private let sleepService: SleepGRPCService

    init(sleepService: SleepGRPCService = GRPCServiceFactory.shared.sleepService) {
        self.sleepService = sleepService
    }

    func fetchSleepRecords() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await sleepService.listSleepRecords(
                    page: 1,
                    pageSize: 50,
                    startDate: nil,
                    endDate: nil
                )
                sleepRecords = result.records
            } catch {
                errorMessage = mapError(error)
            }
            isLoading = false
        }
    }

    func createSleepRecord(record: SleepRecordCreate) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await sleepService.createSleepRecord(
                    date: record.date,
                    durationHours: record.durationHours,
                    quality: record.quality.map { Int32($0) },
                    notes: record.notes
                )
                lastActionMessage = "Запись сна сохранена"
                fetchSleepRecords()
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
