//
//  ContentView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isLoggedIn {
            MainTabView()
        }else{
            LoginView()
        }
        
    }
    
//    #Preview {
//        ContentView()
//    }
    
}
