//
//  AuthManager.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 08/04/2026.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // SIGN UP
    func signUp(email: String, password: String) {
        print("Trying to sign up...")
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Signup error:", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                print("Signup success")
                self.user = result?.user
                self.errorMessage = ""
            }
        }
    }
    
    //SIGN IN
    func signIn(email: String, password: String) {
        print("Trying to log in...")
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Login error:", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                print("Login success")
                self.user = result?.user
                self.errorMessage = ""
            }
        }
    }
    
    // SIGN OUT
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                self.user = nil
            }
            
            print("User signed out")
            
        } catch {
            print("Sign out error:", error.localizedDescription)
        }
    }
}
