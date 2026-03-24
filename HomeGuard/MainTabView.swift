//
//  MainTabView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var deviceStore = DeviceStore()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "SurfaceColor")
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "AccentGreen")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentGreen")!]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "TextSecondary")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "TextSecondary")!]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            DevicesView()
                .tabItem {
                    Label("Devices", systemImage: "square.grid.2x2.fill")
                }
                .environmentObject(deviceStore)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(Color("AccentGreen"))
        .environmentObject(deviceStore)
    }
}

#Preview {
    MainTabView()
}
