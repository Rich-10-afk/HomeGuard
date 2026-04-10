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
    @Published var devices: [Device] = []
    @Published var logs: [SecurityLog] = []
    
    private let firestoreManager = FirestoreManager()
    
    init() {
        loadData()
    }
    
    func loadData() {
        firestoreManager.fetchDevices { devices in
            DispatchQueue.main.async {
                self.devices = devices
            }
        }
        
        firestoreManager.fetchLogs { logs in
            DispatchQueue.main.async {
                self.logs = logs
            }
        }
    }
    
    func addDevice(_ device: Device) {
        devices.append(device)
        firestoreManager.addDevice(device)
        
        let log = SecurityLog(
            title: "\(device.name) added",
            subtitle: "User: Richie",
            time: "Just now",
            type: .access
        )
        addLog(log)
    }
    
    func removeDevice(_ device: Device) {
        devices.removeAll { $0.id == device.id }
        firestoreManager.removeDevice(device)
        
        let log = SecurityLog(
            title: "\(device.name) removed",
            subtitle: "User: Richie",
            time: "Just now",
            type: .warning
        )
        addLog(log)
    }
    
    func toggleDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isOnline.toggle()
            devices[index].status = devices[index].isOnline ? "Online" : "Offline"
            devices[index].lastActive = "Just now"
            
            firestoreManager.updateDevice(devices[index])
            
            let log = SecurityLog(
                title: "\(device.name) turned \(devices[index].isOnline ? "On" : "Off")",
                subtitle: "User: Richie",
                time: "Just now",
                type: .access
            )
            addLog(log)
        }
    }
    
    func addLog(_ log: SecurityLog) {
        logs.insert(log, at: 0)
        firestoreManager.addLog(log)
    }
}
