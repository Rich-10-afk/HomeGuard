//
//  AddDeviceView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var deviceStore: DeviceStore
    @State private var searchText = ""
    @State private var addedDevices: Set<Int> = []
    @Environment(\.dismiss) var dismiss
    
    let suggestedDevices = [
        Device(id: 5, name: "Smart Bulb Pro", type: "Smart Light", status: "Online", lastActive: "Just now", isOnline: true),
        Device(id: 6, name: "Door Lock X2", type: "Smart Lock", status: "Online", lastActive: "Just now", isOnline: true),
        Device(id: 7, name: "Nest Thermostat", type: "Thermostat", status: "Online", lastActive: "Just now", isOnline: true),
        Device(id: 8, name: "Smart Doorbell", type: "Doorbell", status: "Online", lastActive: "Just now", isOnline: true)
    ]
    
    var filteredDevices: [Device] {
        if searchText.isEmpty { return suggestedDevices }
        return suggestedDevices.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                Text("Suggested Devices")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                if filteredDevices.isEmpty {
                    EmptyStateView(message: "No devices found")
                        .padding(.horizontal, 20)
                }
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(filteredDevices) { device in
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("AccentGreen").opacity(0.15))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: iconFor(type: device.type))
                                            .foregroundColor(Color("AccentGreen"))
                                            .font(.system(size: 14))
                                    )
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(device.name)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white)
                                    Text(device.type)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color("TextSecondary"))
                                }
                                
                                Spacer()
                                
                                Button {
                                    addDevice(device)
                                } label: {
                                    if addedDevices.contains(device.id) {
                                        Text("Added ✓")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color("TextSecondary"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color("TextSecondary").opacity(0.15))
                                            .cornerRadius(6)
                                    } else {
                                        Text("+ Add")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color("AccentGreen"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color("AccentGreen").opacity(0.15))
                                            .cornerRadius(6)
                                    }
                                }
                                .disabled(addedDevices.contains(device.id))
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
        .navigationTitle("Add Device")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addDevice(_ device: Device) {
        if !deviceStore.devices.contains(where: { $0.id == device.id }) {
            deviceStore.addDevice(device)
            addedDevices.insert(device.id)
            
            let log = SecurityLog(
                title: "\(device.name) added",
                subtitle: "User: Richie",
                time: "Just now",
                type: .access
            )
            deviceStore.logs.insert(log, at: 0)
        }
    }
    
    func iconFor(type: String) -> String {
        switch type {
        case "Smart Light": return "lightbulb.fill"
        case "Smart Lock": return "lock.fill"
        case "Camera": return "camera.fill"
        case "Thermostat": return "thermometer"
        case "Doorbell": return "bell.fill"
        default: return "house.fill"
        }
    }
}

#Preview {
    AddDeviceView()
        .environmentObject(DeviceStore())
}
