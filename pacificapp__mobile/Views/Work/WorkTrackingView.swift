import SwiftUI
import AlertToast

struct WorkTrackingView: View {
    @StateObject private var workViewModel = WorkViewModel()
    @State private var showingAddActivity = false

    private var actionToastBinding: Binding<Bool> {
        Binding(
            get: { workViewModel.lastActionMessage != nil },
            set: { if !$0 { workViewModel.lastActionMessage = nil } }
        )
    }

    private var errorToastBinding: Binding<Bool> {
        Binding(
            get: { workViewModel.errorMessage != nil },
            set: { if !$0 { workViewModel.errorMessage = nil } }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    NavigationLink(destination: WorkStatisticsView()) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                                .font(.subheadline)
                            Text("Статистика")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemGroupedBackground))
                        .foregroundColor(.accentColor)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)

                    Button {
                        showingAddActivity = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.subheadline)
                            Text("Добавить")
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
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Активности")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.horizontal, 4)

                    if workViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding(.vertical, 20)
                            Spacer()
                        }
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                    } else if workViewModel.workActivities.isEmpty {
                        Text("Нет записей")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                    } else {
                        VStack(spacing: 1) {
                            ForEach(workViewModel.workActivities) { activity in
                                WorkActivityRow(activity: activity)
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
        .navigationTitle("Работа")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    workViewModel.fetchWorkActivities()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.subheadline)
                }
            }
        }
        .refreshable {
            workViewModel.fetchWorkActivities()
        }
        .sheet(isPresented: $showingAddActivity) {
            AddWorkActivityView(workViewModel: workViewModel)
        }
        .toast(isPresenting: actionToastBinding) {
            AlertToast(type: .complete(.green), title: workViewModel.lastActionMessage)
        }
        .toast(isPresenting: errorToastBinding) {
            AlertToast(type: .error(.red), title: workViewModel.errorMessage)
        }
        .onAppear {
            workViewModel.fetchWorkActivities()
        }
    }
}

struct WorkActivityRow: View {
    let activity: WorkActivity

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "briefcase.fill")
                .font(.caption)
                .foregroundColor(.blue)
                .frame(width: 28, height: 28)
                .background(Color.blue.opacity(0.12))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(activity.date)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 6) {
                    Label("\(String(format: "%.1f", activity.durationHours)) ч", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    if let productivity = activity.productivity {
                        Text("·")
                            .foregroundColor(.secondary)
                        Label("\(productivity)/10", systemImage: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    if let breaksCount = activity.breaksCount {
                        Text("·")
                            .foregroundColor(.secondary)
                        Label("\(breaksCount)", systemImage: "pause.circle")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            if let notes = activity.notes, !notes.isEmpty {
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
