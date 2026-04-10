//
//  SettingsView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State private var alertsEnabled = true
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Profile card
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color("AccentGreen").opacity(0.15))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color("AccentGreen"))
                            )
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Username")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text("View Profile >")
                                .font(.system(size: 12))
                                .foregroundColor(Color("AccentGreen"))
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color("SurfaceColor"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    
                    // Security section
                    Text("SECURITY")
                        .font(.system(size: 11))
                        .foregroundColor(Color("TextSecondary"))
                    
                    VStack(spacing: 1) {
                        SettingsRow(icon: "lock.fill", title: "Password Change")
                        SettingsToggleRow(icon: "bell.fill", title: "Enable/Disable Alerts", isOn: $alertsEnabled)
                        SettingsRow(icon: "hand.raised.fill", title: "Privacy Settings")
                    }
                    .background(Color("SurfaceColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    
                    // App section
                    Text("APP")
                        .font(.system(size: 11))
                        .foregroundColor(Color("TextSecondary"))
                    
                    VStack(spacing: 1) {
                        SettingsRow(icon: "shield.fill", title: "Security Recommendations")
                        SettingsRow(icon: "bell.badge.fill", title: "Notifications")
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support")
                    }
                    .background(Color("SurfaceColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    
                    // Logout button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("SurfaceColor"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .alert("Log Out", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Log Out", role: .destructive) {
                            authManager.logout()
                        }
                    }message: {
                        Text("Are you sure you want to log out?")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color("AccentGreen"))
                .font(.system(size: 14))
                .frame(width: 20)
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color("TextSecondary"))
                .font(.system(size: 12))
        }
        .padding(14)
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color("AccentGreen"))
                .font(.system(size: 14))
                .frame(width: 20)
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color("AccentGreen"))
        }
        .padding(14)
    }
}

#Preview {
    SettingsView()
}
