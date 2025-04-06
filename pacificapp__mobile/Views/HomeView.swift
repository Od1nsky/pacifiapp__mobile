import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Welcome, \(authViewModel.currentUser?.fullName ?? "User")!")
                .font(.title)
                .padding()
            
            Button(action: {
                authViewModel.logout()
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }
} 