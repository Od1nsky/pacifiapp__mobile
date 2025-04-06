import SwiftUI

struct AddWorkActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var workViewModel: WorkViewModel
    
    @State private var date = Date()
    @State private var durationHours = ""
    @State private var breaksCount = ""
    @State private var breaksTotalMinutes = ""
    @State private var productivity = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Work Details")) {
                    TextField("Duration (hours)", text: $durationHours)
                        .keyboardType(.decimalPad)
                    
                    TextField("Number of Breaks", text: $breaksCount)
                        .keyboardType(.numberPad)
                    
                    TextField("Total Break Time (minutes)", text: $breaksTotalMinutes)
                        .keyboardType(.numberPad)
                    
                    TextField("Productivity (1-10)", text: $productivity)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Work Activity")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveActivity()
                }
                .disabled(durationHours.isEmpty)
            )
        }
    }
    
    private func saveActivity() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let activity = WorkActivityCreate(
            date: dateFormatter.string(from: date),
            durationHours: Double(durationHours) ?? 0,
            breaksCount: Int(breaksCount),
            breaksTotalMinutes: Int(breaksTotalMinutes),
            productivity: Int(productivity),
            notes: notes.isEmpty ? nil : notes
        )
        
        workViewModel.createWorkActivity(activity: activity)
        presentationMode.wrappedValue.dismiss()
    }
} 