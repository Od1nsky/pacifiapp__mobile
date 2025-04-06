import SwiftUI

struct WorkTrackingView: View {
    @StateObject private var workViewModel = WorkViewModel()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Quick Actions")) {
                    NavigationLink(destination: WorkStatisticsView()) {
                        Label("View Statistics", systemImage: "chart.bar")
                    }
                    
                    Button(action: {
                        showingAddActivity = true
                    }) {
                        Label("Add Work Activity", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Recent Activities")) {
                    if workViewModel.isLoading {
                        ProgressView()
                    } else if workViewModel.workActivities.isEmpty {
                        Text("No activities recorded")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(workViewModel.workActivities) { activity in
                            WorkActivityRow(activity: activity)
                        }
                    }
                }
            }
            .navigationTitle("Work Tracking")
            .onAppear {
                workViewModel.fetchWorkActivities()
            }
            .sheet(isPresented: $showingAddActivity) {
                AddWorkActivityView(workViewModel: workViewModel)
            }
        }
    }
}

struct WorkActivityRow: View {
    let activity: WorkActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(activity.date)
                .font(.headline)
            
            HStack {
                Label("\(String(format: "%.1f", activity.durationHours)) hours", systemImage: "clock")
                Spacer()
                if let productivity = activity.productivity {
                    Label("\(productivity)/10", systemImage: "star")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if let notes = activity.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 