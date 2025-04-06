import SwiftUI
import Charts

struct WorkStatisticsView: View {
    @StateObject private var workViewModel = WorkViewModel()
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate = Date()
    
    var body: some View {
        List {
            Section(header: Text("Date Range")) {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                
                Button("Update Statistics") {
                    fetchStatistics()
                }
            }
            
            if workViewModel.isLoading {
                Section {
                    ProgressView()
                }
            } else if let statistics = workViewModel.workStatistics {
                Section(header: Text("Summary")) {
                    StatRow(title: "Average Duration", value: "\(String(format: "%.1f", statistics.averageDuration)) hours")
                    
                    if let productivity = statistics.averageProductivity {
                        StatRow(title: "Average Productivity", value: "\(String(format: "%.1f", productivity))/10")
                    }
                    
                    if let breaksCount = statistics.averageBreaksCount {
                        StatRow(title: "Average Breaks", value: "\(String(format: "%.1f", breaksCount))")
                    }
                    
                    if let breaksDuration = statistics.averageBreaksDuration {
                        StatRow(title: "Average Break Duration", value: "\(String(format: "%.1f", breaksDuration)) minutes")
                    }
                    
                    StatRow(title: "Total Records", value: "\(statistics.totalRecords)")
                }
                
                Section(header: Text("Daily Work Hours")) {
                    Chart(statistics.dailyData) { data in
                        BarMark(
                            x: .value("Date", data.date),
                            y: .value("Hours", data.durationHours)
                        )
                    }
                    .frame(height: 200)
                }
            }
        }
        .navigationTitle("Work Statistics")
        .onAppear {
            fetchStatistics()
        }
    }
    
    private func fetchStatistics() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        workViewModel.fetchWorkStatistics(
            startDate: dateFormatter.string(from: startDate),
            endDate: dateFormatter.string(from: endDate)
        )
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
} 