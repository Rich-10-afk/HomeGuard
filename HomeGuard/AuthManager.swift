import Foundation
import Firebase
import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    init() {
        // Check if user is already logged in
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.currentUser = user
                self.isLoggedIn = true
            } else {
                self.currentUser = nil
                self.isLoggedIn = false
            }
        }
    }
    
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.currentUser = result?.user
            self.isLoggedIn = true
        }
    }
    
    
    func register(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.currentUser = result?.user
            self.isLoggedIn = true
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
