//
//  HomeGuardApp.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI
import Firebase

@main
struct HomeGuardApp: App {
    @StateObject private var deviceStore = DeviceStore()
    @StateObject private var authManager = AuthManager()
    
    init(){
        FirebaseApp.configure()
        print("Configuring Firebase")
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(deviceStore).environmentObject(authManager)
        }
    }
}
