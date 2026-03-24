//
//  DeviceDetailsView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct DeviceDetailsView: View {
    
    let device: Device
    @EnvironmentObject var deviceStore: DeviceStore
    @State private var showRemoveAlert = false
    @Environment(\.dismiss) var dismiss
    
    var currentDevice: Device {
        deviceStore.devices.first { $0.id == device.id } ?? device
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Hero card
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentDevice.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text("\(currentDevice.type) · Last active \(currentDevice.lastActive)")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color("TextSecondary"))
                            }
                            Spacer()
                        }
                        Text(currentDevice.status)
                            .font(.system(size: 11))
                            .foregroundColor(currentDevice.isOnline ? Color("AccentGreen") : Color("TextSecondary"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(currentDevice.isOnline ? Color("AccentGreen").opacity(0.15) : Color("TextSecondary").opacity(0.15))
                            .cornerRadius(6)
                    }
                    .padding(14)
                    .background(Color("SurfaceColor"))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("AccentGreen").opacity(0.3), lineWidth: 1)
                    )
                    
                    // Access History
                    let deviceLogs = deviceStore.logs.filter {
                        $0.title.contains(currentDevice.name)
                    }
                    
                    Text("Access History")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if deviceLogs.filter({ $0.type == .access }).isEmpty {
                        EmptyStateView(message: "No access history yet")
                    } else {
                        VStack(spacing: 8) {
                            ForEach(deviceLogs.filter { $0.type == .access }) { log in
                                LogRow(title: log.title, subtitle: log.subtitle, dotColor: Color("AccentGreen"))
                            }
                        }
                    }
                    
                    // Security Alerts
                    Text("Security Alerts")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if deviceLogs.filter({ $0.type != .access }).isEmpty {
                        EmptyStateView(message: "No security alerts")
                    } else {
                        VStack(spacing: 8) {
                            ForEach(deviceLogs.filter { $0.type != .access }) { log in
                                LogRow(
                                    title: log.title,
                                    subtitle: log.subtitle,
                                    dotColor: log.type == .warning ? .orange : .red
                                )
                            }
                        }
                    }
                    
                    // Turn On/Off toggle
                    HStack {
                        Text("Turn On/Off")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { currentDevice.isOnline },
                            set: { _ in deviceStore.toggleDevice(currentDevice) }
                        ))
                        .tint(Color("AccentGreen"))
                    }
                    .padding(14)
                    .background(Color("SurfaceColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    
                    // Remove Device button
                    Button {
                        showRemoveAlert = true
                    } label: {
                        Text("Remove Device")
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(currentDevice.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Remove Device", isPresented: $showRemoveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                deviceStore.removeDevice(currentDevice)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to remove \(currentDevice.name)?")
        }
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "tray")
                    .foregroundColor(Color("TextSecondary"))
                    .font(.system(size: 24))
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(Color("TextSecondary"))
            }
            .padding(20)
            Spacer()
        }
        .background(Color("SurfaceColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

struct LogRow: View {
    let title: String
    let subtitle: String
    let dotColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color("TextSecondary"))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color("TextSecondary"))
                .font(.system(size: 12))
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

#Preview {
    DeviceDetailsView(device: Device(id: 1, name: "Front Door Lock", type: "Smart Lock", status: "Online", lastActive: "9:41 AM", isOnline: true))
        .environmentObject(DeviceStore())
}
