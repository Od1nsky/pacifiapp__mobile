import SwiftUI
import Charts
import AlertToast

struct WorkStatisticsView: View {
    @StateObject private var workViewModel = WorkViewModel()
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate = Date()

    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { workViewModel.errorMessage != nil },
            set: { if !$0 { workViewModel.errorMessage = nil } }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Period section
                VStack(spacing: 8) {
                    DatePicker("Начало", selection: $startDate, displayedComponents: .date)
                        .font(.subheadline)
                    DatePicker("Конец", selection: $endDate, displayedComponents: .date)
                        .font(.subheadline)

                    Button {
                        fetchStatistics()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.caption)
                            Text("Обновить")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)

                if workViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding(.vertical, 20)
                        Spacer()
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                } else if let statistics = workViewModel.workStatistics {
                    // Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Сводка")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, 4)

                        VStack(spacing: 1) {
                            CompactStatRow(title: "Средняя длительность", value: "\(String(format: "%.1f", statistics.averageDuration)) ч")

                            if let productivity = statistics.averageProductivity {
                                CompactStatRow(title: "Продуктивность", value: "\(String(format: "%.1f", productivity))/10")
                            }

                            if let breaksCount = statistics.averageBreaksCount {
                                CompactStatRow(title: "Перерывы", value: "\(String(format: "%.1f", breaksCount))")
                            }

                            if let breaksDuration = statistics.averageBreaksDuration {
                                CompactStatRow(title: "Длит. перерывов", value: "\(String(format: "%.1f", breaksDuration)) мин")
                            }

                            CompactStatRow(title: "Записей", value: "\(statistics.totalRecords)")
                        }
                        .cornerRadius(10)
                    }

                    // Chart
                    if !statistics.dailyData.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Нагрузка")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 4)

                            Chart(statistics.dailyData) { data in
                                BarMark(
                                    x: .value("Дата", data.date),
                                    y: .value("Часы", data.durationHours)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                            .frame(height: 180)
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                        }
                    }
                } else {
                    Text("Выберите период и нажмите «Обновить»")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Статистика")
        .onAppear {
            fetchStatistics()
        }
        .toast(isPresenting: errorToastBinding) {
            AlertToast(type: .error(.red), title: workViewModel.errorMessage)
        }
    }

    private func fetchStatistics() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        workViewModel.fetchWorkStatistics(
            startDate: formatter.string(from: startDate),
            endDate: formatter.string(from: endDate)
        )
    }
}

private struct CompactStatRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
    }
}
