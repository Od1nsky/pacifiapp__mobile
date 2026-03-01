//
//  pacificapp__mobileApp.swift
//  pacificapp__mobile
//
//  Created by Vladislav Kapustian on 13.03.2025.
//

import SwiftUI

@main
struct pacificapp__mobileApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                TabView {
                    NavigationStack {
                        HomeView()
                    }
                    .tabItem {
                        Label("Дом", systemImage: "house")
                    }
                    .environmentObject(authViewModel)

                    NavigationStack {
                        SleepTrackingView()
                    }
                    .tabItem {
                        Label("Сон", systemImage: "bed.double.fill")
                    }

                    NavigationStack {
                        WorkTrackingView()
                    }
                    .tabItem {
                        Label("Работа", systemImage: "briefcase")
                    }

                    NavigationStack {
                        RecommendationsView()
                    }
                    .tabItem {
                        Label("Рекомендации", systemImage: "sparkles")
                    }
                }
                .environmentObject(authViewModel)
            } else {
                NavigationStack {
                    LoginView()
                }
                .environmentObject(authViewModel)
            }
        }
    }
}
