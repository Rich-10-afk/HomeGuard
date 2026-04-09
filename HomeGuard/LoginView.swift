//
//  LoginView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            
            if authVM.user != nil {
                MainTabView()
            }else {
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
                        
                        // Login button
                        Button{
                            authVM.signIn(email: email, password: password)
                        }label: {
                            Text("Login")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("BackgroundPrimary"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentGreen"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 24)
                        
                        Button{
                            authVM.signUp(email: email, password: password)
                        }label: {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("BackgroundPrimary"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("AccentGreen"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 24)
                        
//                        Button {
//                            
//                        } label: {
//                            Text("Forgot Password?")
//                                .foregroundColor(Color("AccentGreen"))
//                                .font(.system(size: 14))
//                        }
                        
                        Spacer()
                    }
                }
                
            }
            
        }
    }
}

#Preview {
    LoginView()
}
