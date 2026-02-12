//
//  RootView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RootView: View {

    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                MainTabView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
    }
}


    
   /* func observeAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                fetchUserRole(uid: user.uid)
            } else {
                isLoggedIn = false
                role = ""
                isLoading = false
            }
        }
    }*/

   
   

/*import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RootView: View {

    @State private var isLoggedIn = false
    @State private var userRole: String? = nil
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if !isLoggedIn {
                LoginView()
            } else if userRole == "admin" {
                AdminDashboardView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            listenToAuthState()
        }
    }

    // MARK: - Listen to Auth Changes
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                isLoggedIn = true
                fetchUserRole(userId: user.uid)
            } else {
                isLoggedIn = false
                userRole = nil
                isLoading = false
            }
        }
    }

    // MARK: - Fetch Role from Firestore
    func fetchUserRole(userId: String) {
        isLoading = true

        Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument { snapshot, _ in

                DispatchQueue.main.async {
                    if let data = snapshot?.data(),
                       let role = data["role"] as? String {
                        self.userRole = role
                    } else {
                        self.userRole = "user"
                    }
                    self.isLoading = false
                }
            }
    }

    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout error:", error.localizedDescription)
        }
    }
}
*/

