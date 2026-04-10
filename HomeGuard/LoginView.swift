//
//  LoginView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary")
                .ignoresSafeArea()
                    
            VStack(spacing: 20) {
                        
                Spacer()
                        
                // Logo placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("SurfaceColor"))
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                            )
                        
                Spacer().frame(height: 20)
                        
                // Email field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color("SurfaceColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("BorderColor"), lineWidth: 1)
                            )
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                        
                        // Password field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color("SurfaceColor"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderColor"), lineWidth: 1)
                            )
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                
                if !authManager.errorMessage.isEmpty {
                    Text(authManager.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.horizontal, 24)
                }
                
                        
                // Login button
                Button{
                    if isRegistering {
                        authManager.register(email: email, password: password)
                        
                    }else{
                        authManager.login(email: email, password: password)
                    }
                    } label: {
                        if authManager.isLoading {
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("BackgroundPrimary")))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentGreen"))
                                .cornerRadius(10)
                        } else {
                            Text(isRegistering ? "Register" : "Login")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("BackgroundPrimary"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentGreen"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 24)
                                        
                // Toggle between login and register
                Button {
                    isRegistering.toggle()
                    authManager.errorMessage = ""
                }label: {
                    Text(isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                        .foregroundColor(Color("AccentGreen"))
                        .font(.system(size: 14))
                    }
                                        
                Spacer()
                }
                
            }
            
        }
    }


#Preview {
    LoginView().environmentObject(AuthManager())
}
