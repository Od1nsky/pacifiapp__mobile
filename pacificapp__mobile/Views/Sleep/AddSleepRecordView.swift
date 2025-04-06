import SwiftUI

struct AddSleepRecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sleepViewModel: SleepViewModel
    
    @State private var date = Date()
    @State private var durationHours = ""
    @State private var quality = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Sleep Details")) {
                    TextField("Duration (hours)", text: $durationHours)
                        .keyboardType(.decimalPad)
                    
                    TextField("Quality (1-10)", text: $quality)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Sleep Record")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveRecord()
                }
                .disabled(durationHours.isEmpty)
            )
        }
    }
    
    private func saveRecord() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let record = SleepRecordCreate(
            date: dateFormatter.string(from: date),
            durationHours: Double(durationHours) ?? 0,
            quality: Int(quality),
            notes: notes.isEmpty ? nil : notes
        )
        
        sleepViewModel.createSleepRecord(record: record)
        presentationMode.wrappedValue.dismiss()
    }
} 