import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List {
            Section(header: Text("Профиль")) {
                if let user = authViewModel.currentUser {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let stress = user.stressLevelBase {
                            Label("Базовый стресс: \(stress)", systemImage: "waveform.path.ecg")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)

                    Button {
                        authViewModel.refreshProfile()
                    } label: {
                        Label("Обновить профиль", systemImage: "arrow.clockwise")
                    }
                } else if authViewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Профиль будет загружен после авторизации.")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Навигация")) {
                NavigationLink(destination: SleepTrackingView()) {
                    Label("Отслеживание сна", systemImage: "bed.double.fill")
                }

                NavigationLink(destination: WorkTrackingView()) {
                    Label("Рабочие активности", systemImage: "briefcase.fill")
                }

                NavigationLink(destination: RecommendationsView()) {
                    Label("Рекомендации", systemImage: "sparkles")
                }
            }

            Section(header: Text("Сеанс")) {
                Button(role: .destructive) {
                    authViewModel.logout()
                } label: {
                    Label("Выйти", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Главная")
    }
}