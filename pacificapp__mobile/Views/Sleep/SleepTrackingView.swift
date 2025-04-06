import SwiftUI

struct SleepTrackingView: View {
    @StateObject private var sleepViewModel = SleepViewModel()
    @State private var showingAddRecord = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Quick Actions")) {
                    Button(action: {
                        showingAddRecord = true
                    }) {
                        Label("Add Sleep Record", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Recent Sleep Records")) {
                    if sleepViewModel.isLoading {
                        ProgressView()
                    } else if sleepViewModel.sleepRecords.isEmpty {
                        Text("No sleep records")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(sleepViewModel.sleepRecords) { record in
                            SleepRecordRow(record: record)
                        }
                    }
                }
            }
            .navigationTitle("Sleep Tracking")
            .onAppear {
                sleepViewModel.fetchSleepRecords()
            }
            .sheet(isPresented: $showingAddRecord) {
                AddSleepRecordView(sleepViewModel: sleepViewModel)
            }
        }
    }
}

struct SleepRecordRow: View {
    let record: SleepRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(record.date)
                .font(.headline)
            
            HStack {
                Label("\(String(format: "%.1f", record.durationHours)) hours", systemImage: "clock")
                Spacer()
                if let quality = record.quality {
                    Label("\(quality)/10", systemImage: "star")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if let notes = record.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 