//
//  SecurityLogsView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct SecurityLogsView: View {
    
    @EnvironmentObject var deviceStore: DeviceStore
    @State private var searchText = ""
    
    var filteredLogs: [SecurityLog] {
        if searchText.isEmpty { return deviceStore.logs }
        return deviceStore.logs.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
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
            
            VStack(alignment: .leading, spacing: 16) {
                
                // Summary card
                HStack {
                    StatCard(value: "\(deviceStore.logs.count)", label: "Total Events")
                    Divider().background(Color("BorderColor"))
                    StatCard(value: "\(deviceStore.logs.filter { $0.type == .access }.count)", label: "Access Records")
                    Divider().background(Color("BorderColor"))
                    StatCard(
                        value: "\(deviceStore.logs.filter { $0.type != .access }.count)",
                        label: "Alerts",
                        valueColor: .orange
                    )
                }
                .padding(14)
                .background(Color("SurfaceColor"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("BorderColor"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                
                Text("Today")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                if filteredLogs.isEmpty {
                    EmptyStateView(message: "No logs found")
                        .padding(.horizontal, 20)
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(filteredLogs) { log in
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill(colorFor(log.type))
                                        .frame(width: 8, height: 8)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(log.title)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.white)
                                        Text(log.subtitle)
                                            .font(.system(size: 11))
                                            .foregroundColor(Color("TextSecondary"))
                                    }
                                    Spacer()
                                    Text(log.time)
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
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationTitle("Security Logs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    var valueColor: Color = .white
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(valueColor)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Color("TextSecondary"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SecurityLogsView()
        .environmentObject(DeviceStore())
}
