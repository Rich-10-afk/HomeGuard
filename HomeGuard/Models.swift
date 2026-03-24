//
//  Models.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import Foundation
import Combine


struct Device: Identifiable {
    let id: Int
    let name: String
    let type: String
    var status: String
    var lastActive: String
    var isOnline: Bool
}

struct SecurityLog: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let type: LogType
    
    enum LogType {
        case access, warning, danger
    }
}

class DeviceStore: ObservableObject {
    @Published var devices: [Device] = [
        Device(id: 1, name: "Front Door Lock", type: "Smart Lock", status: "Online", lastActive: "9:41 AM", isOnline: true),
        Device(id: 2, name: "Back Door Lock", type: "Smart Lock", status: "Offline", lastActive: "10:41 AM", isOnline: false),
        Device(id: 3, name: "Security Camera", type: "Camera", status: "Online", lastActive: "10:41 AM", isOnline: true),
        Device(id: 4, name: "Living Room Light", type: "Smart Light", status: "Offline", lastActive: "9:30 AM", isOnline: false)
    ]
    
    @Published var logs: [SecurityLog] = [
        SecurityLog(title: "Front Door Unlocked", subtitle: "User: Richie", time: "9:41 AM", type: .access),
        SecurityLog(title: "Failed Login Attempt", subtitle: "Unknown user", time: "8:30 AM", type: .warning),
        SecurityLog(title: "Smart Light Turned On", subtitle: "User: Richie", time: "7:15 AM", type: .access),
        SecurityLog(title: "Unauthorised Access", subtitle: "Unknown device", time: "6:50 AM", type: .danger)
    ]
    
    func addDevice(_ device: Device) {
        devices.append(device)
    }
    
    func removeDevice(_ device: Device) {
        devices.removeAll { $0.id == device.id }
    }
    
    func toggleDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isOnline.toggle()
            devices[index].status = devices[index].isOnline ? "Online" : "Offline"
            devices[index].lastActive = "Just now"
            
            let log = SecurityLog(
                title: "\(device.name) turned \(devices[index].isOnline ? "On" : "Off")",
                subtitle: "User: Richie",
                time: "Just now",
                type: .access
            )
            logs.insert(log, at: 0)
        }
    }
}
