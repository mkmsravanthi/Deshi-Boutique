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

    @State private var isLoggedIn = false
    @State private var role: String = ""
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if !isLoggedIn {
                LoginView()
            } else if role == "admin" {
                AdminDashboardView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            observeAuthState()
        }
    }

    // MARK: - Observe Auth State
    func observeAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                print("AUTH UID:", user.uid)   // 👈 ADD THIS
                fetchUserRole(uid: user.uid)
            } else {
                isLoggedIn = false
                role = ""
                isLoading = false
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

    // MARK: - Fetch Role (ONLY PLACE)
    func fetchUserRole(uid: String) {
        isLoading = true

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.role = snapshot?.data()?["role"] as? String ?? "user"
                    self.isLoading = false

                    print("Logged in as role:", self.role) // 🔍 DEBUG
                }
            }
    }
}





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

