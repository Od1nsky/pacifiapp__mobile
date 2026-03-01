import SwiftUI
import AlertToast

struct SleepTrackingView: View {
    @StateObject private var sleepViewModel = SleepViewModel()
    @State private var showingAddRecord = false

    private var actionToastBinding: Binding<Bool> {
        Binding(
            get: { sleepViewModel.lastActionMessage != nil },
            set: { if !$0 { sleepViewModel.lastActionMessage = nil } }
        )
    }

    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { sleepViewModel.errorMessage != nil },
            set: { if !$0 { sleepViewModel.errorMessage = nil } }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Button {
                    showingAddRecord = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.subheadline)
                        Text("Добавить запись")
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("Записи сна")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.horizontal, 4)

                    if sleepViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding(.vertical, 20)
                            Spacer()
                        }
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                    } else if sleepViewModel.sleepRecords.isEmpty {
                        Text("Записей пока нет")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                    } else {
                        VStack(spacing: 1) {
                            ForEach(sleepViewModel.sleepRecords) { record in
                                SleepRecordRow(record: record)
                            }
                        }
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Сон")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sleepViewModel.fetchSleepRecords()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.subheadline)
                }
            }
        }
        .refreshable {
            sleepViewModel.fetchSleepRecords()
        }
        .sheet(isPresented: $showingAddRecord) {
            AddSleepRecordView(sleepViewModel: sleepViewModel)
        }
        .toast(isPresenting: actionToastBinding) {
            AlertToast(type: .complete(.green), title: sleepViewModel.lastActionMessage)
        }
        .toast(isPresenting: errorToastBinding) {
            AlertToast(type: .error(.red), title: sleepViewModel.errorMessage)
        }
        .onAppear {
            sleepViewModel.fetchSleepRecords()
        }
    }
}

struct SleepRecordRow: View {
    let record: SleepRecord

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "moon.fill")
                .font(.caption)
                .foregroundColor(.indigo)
                .frame(width: 28, height: 28)
                .background(Color.indigo.opacity(0.12))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.date)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 6) {
                    Label("\(String(format: "%.1f", record.durationHours)) ч", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    if let quality = record.quality {
                        Text("·")
                            .foregroundColor(.secondary)
                        Label("\(quality)/10", systemImage: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            if let notes = record.notes, !notes.isEmpty {
                Image(systemName: "note.text")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
    }
}
