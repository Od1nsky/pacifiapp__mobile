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
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    WorkTrackingView()
                        .tabItem {
                            Label("Work", systemImage: "briefcase")
                        }
                }
                .environmentObject(authViewModel)
            } else {
                NavigationView {
                    LoginView()
                }
                .environmentObject(authViewModel)
            }
        }
    }
}
