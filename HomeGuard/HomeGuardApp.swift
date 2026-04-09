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
    
    init(){
        FirebaseApp.configure()
        print("Configuring Firebase")
    }
    
    @StateObject private var deviceStore = DeviceStore()
    @StateObject private var authVM = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(deviceStore).environmentObject(authVM)
        }
    }
}
