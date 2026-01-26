//
//  RegisterView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {

                Text("Create Account")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)

                TextField("Full Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button {
                    register()
                } label: {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(30)
                }

                Spacer()
            }
            .padding()
        }
    }

    // MARK: - Register + Save User
    func register() {
        Auth.auth()
            .createUser(withEmail: email, password: password) { result, error in

                guard let user = result?.user else { return }

                Firestore.firestore()
                    .collection("users")
                    .document(user.uid)
                    .setData([
                            "name": name,
                            "email": email,
                            "role": "user"
                        ], merge: true)
            }
    }
}
