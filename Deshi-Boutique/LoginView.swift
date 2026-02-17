//
//  LoginView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var loginSuccess = false          // 🔹 Controls navigation
    @State private var loginError = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false// 🔹 Optional error display
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                VStack(spacing: 30) {
                    
                    Spacer()
                    
                    // 🌸 Welcome Text
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    
                    // 🖼 Logo
                    Image("desh_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 210)
                        .border(Color.red)
                    
                    Spacer()
                    
                    // 📧 Email
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .autocapitalization(.none)

                    // 🔒 Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                    
                    // 🔐 Login Button
                    Button {
                        loginUser()
                    } label: {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    
                    
                    // Show login error if any
                    if !loginError.isEmpty {
                        Text(loginError)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Text("OR")
                        .foregroundColor(.white)
                    
                    // 📝 Register Button
                    NavigationLink(destination: RegisterView()) {
                        Text("Register Now")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // 🔹 Hidden NavigationLink triggered after login
                    NavigationLink(destination: RegisterView(), isActive: $loginSuccess) {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    // MARK: - Firebase Login
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            } else {
                isLoggedIn = true
                dismiss()
            }
        }
    }
}
    
    
    
    /*  // MARK: - Login
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                loginError = error.localizedDescription
            } else {
                // Successful login → navigate to HomeView
                loginSuccess = true
            }
        }
    }
}*/





/*import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {

                // 🌄 Background Image
                AppBackground()

                // Dark overlay for readability

                VStack(spacing: 20) {

                    Spacer()

                    // 🛍 App Title
                    Text("Boutique App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // 📧 Email
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .autocapitalization(.none)

                    // 🔒 Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)

                    // 🔐 Login Button
                    Button(action: loginUser) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    // 🆕 Register Button
                    Button(action: registerUser) {
                        Text("Create New Account")
                            .foregroundColor(.white)
                            .underline()
                    }

                    // ❌ Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.cyan)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    // Navigation
                  //  NavigationLink("", destination: RootView(), isActive: $isLoggedIn)
                }
                .padding()
            }
        }
    }

    // MARK: - Firebase Login
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            } else {
                isLoggedIn = true
            }
        }
    }

    // MARK: - Firebase Register
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            } else {
                isLoggedIn = true
            }
        }
    }
}
*/
