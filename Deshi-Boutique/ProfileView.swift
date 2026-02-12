//
//  ProfileView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    
    @State private var user: User? = Auth.auth().currentUser
    @State private var name = ""
    @State private var email = ""
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            
            if user == nil {
                
                LoginView()
                    .navigationTitle("Login")
                
            } else {
                
                VStack(spacing: 20) {
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(email)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Logout
                    Button(role: .destructive) {
                        try? Auth.auth().signOut()
                    } label: {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    // Delete Account (Apple Required)
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text("Delete Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .navigationTitle("Profile")
                .onAppear {
                    fetchUserData()
                }
                .alert("Are you sure you want to delete your account?", isPresented: $showDeleteAlert) {
                    
                    Button("Delete", role: .destructive) {
                        deleteAccount()
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .onAppear {
            listenToAuth()
        }
    }
    
    // MARK: - Auth Listener
    
    func listenToAuth() {
        Auth.auth().addStateDidChangeListener { _, firebaseUser in
            self.user = firebaseUser
        }
    }
    
    // MARK: - Fetch User Data
    
    func fetchUserData() {
        guard let uid = user?.uid else { return }
        
        email = user?.email ?? ""
        
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                let data = snapshot?.data()
                name = data?["name"] as? String ?? "User"
            }
    }
    
    // MARK: - Delete Account
    
    func deleteAccount() {
        guard let user = user else { return }
        
        let uid = user.uid
        
        // Delete Firestore user document
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .delete()
        
        // Delete Auth account
        user.delete { error in
            if let error = error {
                print("Error deleting account:", error)
            } else {
                print("Account deleted successfully")
            }
        }
    }
}


/*import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var role = ""

    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text(name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(email)
                    .foregroundColor(.gray)

                Text("Role: \(role.capitalized)")
                    .font(.subheadline)

                Spacer()

                Button(role: .destructive) {
                    try? Auth.auth().signOut()
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Profile")
            .onAppear {
                fetchUserData()
            }
        }
    }

    // MARK: - Fetch User Data
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }

        email = user.email ?? ""

        Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .getDocument { snapshot, _ in
                let data = snapshot?.data()
                name = data?["name"] as? String ?? "User"
                role = data?["role"] as? String ?? "user"
            }
    }
}
*/
