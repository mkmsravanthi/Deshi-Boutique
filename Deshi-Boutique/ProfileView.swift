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
