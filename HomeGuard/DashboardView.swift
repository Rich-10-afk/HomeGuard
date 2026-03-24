//
//  DashboardView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var deviceStore: DeviceStore
    
    var recentAlerts: [SecurityLog] {
        Array(deviceStore.logs.prefix(3))
    }
    
    func colorFor(_ type: SecurityLog.LogType) -> Color {
        switch type {
        case .access: return Color("AccentGreen")
        case .warning: return .orange
        case .danger: return .red
        }
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Nav bar
                    HStack {
                        Text("HomeGuard")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "gearshape")
                            .foregroundColor(Color("TextSecondary"))
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Security status card
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Security Status")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("TextSecondary"))
                                Text("Home Secure ✓")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("Active")
                                .font(.system(size: 11))
                                .foregroundColor(Color("AccentGreen"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color("AccentGreen").opacity(0.15))
                                .cornerRadius(6)
                        }
                        Text("All \(deviceStore.devices.filter { $0.isOnline }.count) devices online · Last checked 9:41 AM")
                            .font(.system(size: 11))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    .padding(14)
                    .background(Color("SurfaceColor"))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("AccentGreen").opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Quick access buttons
                    HStack(spacing: 10) {
                        NavigationLink(destination: AddDeviceView()) {
                            QuickAccessButton(icon: "plus.circle.fill", label: "Add Device")
                        }
                        NavigationLink(destination: SecurityLogsView()) {
                            QuickAccessButton(icon: "shield.fill", label: "Logs")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Recent alerts title
                    Text("Recent Alerts")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    // Recent alerts list
                    if recentAlerts.isEmpty {
                        EmptyStateView(message: "No recent alerts")
                            .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(recentAlerts) { alert in
                                HStack {
                                    Circle()
                                        .fill(colorFor(alert.type))
                                        .frame(width: 8, height: 8)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(alert.title)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.white)
                                        Text(alert.subtitle)
                                            .font(.system(size: 11))
                                            .foregroundColor(Color("TextSecondary"))
                                    }
                                    Spacer()
                                    Text(alert.time)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color("TextSecondary"))
                                }
                                .padding(12)
                                .background(Color("SurfaceColor"))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("BorderColor"), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

struct QuickAccessButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(Color("AccentGreen"))
                .font(.system(size: 22))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color("TextSecondary"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(Color("SurfaceColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

#Preview {
    DashboardView()
        .environmentObject(DeviceStore())
}
