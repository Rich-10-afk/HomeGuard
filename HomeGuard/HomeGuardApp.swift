//
//  HomeGuardApp.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

@main
struct HomeGuardApp: App {
    
    @StateObject private var deviceStore = DeviceStore()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(deviceStore)
        }
    }
}
