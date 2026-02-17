//
//  CartView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CartView: View {

    @EnvironmentObject var cart: CartManager

    @State private var user: User? = Auth.auth().currentUser
    @State private var showOrderAlert = false
    @State private var showLoginSheet = false
    @State private var showDeleteConfirm = false
    @State private var confirmationMessage = ""
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationStack {

            VStack(spacing: 16) {

                // 🛒 CART CONTENT (ALWAYS VISIBLE)
                if cart.items.isEmpty {
                    Spacer()
                    Text("Your cart is empty")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(cart.items) { item in
                                CartRow(item: item, cart: _cart)
                            }
                        }
                        .padding()
                    }
                }

                // 🔽 BOTTOM ACTIONS
                VStack(spacing: 12) {

                    if !cart.items.isEmpty {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("\(cart.totalPrice, specifier: "%.2f") kr")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }

                    // ✅ Confirm & Proceed
                    Button {
                        if user == nil {
                            showLoginSheet = true   // 🔐 login only here
                        } else {
                            confirmOrder()
                        }
                    } label: {
                        Text("Confirm & Proceed")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cart.items.isEmpty ? Color.gray : Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .font(.headline)
                    }
                    .disabled(cart.items.isEmpty)

                    // 📦 Order history (only if logged in)
                    if user != nil {
                        NavigationLink(destination: OrderHistoryView()) {
                            Text("View My Orders")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .font(.headline)
                        }

                        // ❌ Delete Account (Apple required)
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Text("Delete Account")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(radius: 5)
            }
            .navigationTitle("My Cart")
            .alert("Order Status", isPresented: $showOrderAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(confirmationMessage)
            }
            .confirmationDialog(
                "Delete Account",
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button("Delete Account", role: .destructive) {
                    deleteAccount()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete your account and all data. This action cannot be undone.")
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
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

    // MARK: - Confirm Order
    func confirmOrder() {
        let orderNo = generateOrderNumber()

        confirmationMessage = """
        ✅ Order Confirmed!

        Order No: \(orderNo)
        Total: \(cart.totalPrice, default: "%.2f") kr
        """

        saveOrder()
        cart.items.removeAll()
        showOrderAlert = true
    }

    // MARK: - Save Order
    func saveOrder() {
        let orderNo = generateOrderNumber()

        let itemsData = cart.items.map { item in
            [
                "name": item.product.name,
                "price": item.product.price,
                "size": item.size.rawValue,
                "quantity": item.quantity,
                "imageUrl": item.product.imageUrl
            ]
        }

        let orderData: [String: Any] = [
            "orderNumber": orderNo,
            "userId": user?.uid ?? "",
            "total": Double(cart.totalPrice),
            "date": Timestamp(date: Date()),
            "items": itemsData
        ]

        Firestore.firestore()
            .collection("orders")
            .addDocument(data: orderData)
    }

    // MARK: - Delete Account (Apple required)
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid

        Firestore.firestore().collection("users").document(uid).delete { _ in
            user.delete { error in
                if let error = error {
                    print("❌ Delete failed:", error)
                } else {
                    print("✅ Account deleted")
                    cart.items.removeAll()
                }
            }
        }
    }

    func generateOrderNumber() -> String {
        "ORD-\(Int(Date().timeIntervalSince1970))"
    }
}


/*struct CartView: View {
    
    @EnvironmentObject var cart: CartManager
    
    @State private var user: User? = Auth.auth().currentUser
    @State private var showAlert = false
    @State private var confirmationMessage = ""
    
    var body: some View {
           NavigationStack {
               
               VStack(spacing: 16) {
                   
                   if user == nil {
                       // 🔐 Not logged in
                       LoginView()
                           .navigationTitle("Login Required")
                   } else {
                       // 🛒 Logged in → Show cart
                       
                       if cart.items.isEmpty {
                           Spacer()
                           Text("Your cart is empty")
                               .font(.headline)
                               .foregroundColor(.gray)
                           Spacer()
                       } else {
                           ScrollView {
                               VStack(spacing: 20) {
                                   ForEach(cart.items) { item in
                                       CartRow(item: item, cart: _cart)
                                   }
                               }
                               .padding()
                           }
                       }
                       
                       // Bottom buttons always visible
                       VStack(spacing: 12) {
                           
                           // Total price only if cart not empty
                           if !cart.items.isEmpty {
                               HStack {
                                   Text("Total")
                                       .font(.headline)
                                   Spacer()
                                   Text("\(cart.totalPrice, specifier: "%.2f") kr")
                                       .font(.title2)
                                       .fontWeight(.bold)
                               }
                           }
                           
                           // Confirm button
                           Button {
                               confirmOrder()
                           } label: {
                               Text("Confirm & Proceed")
                                   .frame(maxWidth: .infinity)
                                   .padding()
                                   .background(cart.items.isEmpty ? Color.gray : Color.black)
                                   .foregroundColor(.white)
                                   .cornerRadius(14)
                                   .font(.headline)
                           }
                           .disabled(cart.items.isEmpty) // disabled if no items
                           
                           // View Orders button
                           NavigationLink(destination: OrderHistoryView()) {
                               Text("View My Orders")
                                   .frame(maxWidth: .infinity)
                                   .padding()
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(14)
                                   .font(.headline)
                           }
                       }
                       .padding()
                       .background(Color(.systemBackground))
                       .shadow(radius: 5)
                   }
               }
               .navigationTitle("My Cart")
               .alert("Order Status", isPresented: $showAlert) {
                   Button("OK", role: .cancel) { }
               } message: {
                   Text(confirmationMessage)
               }
           }
           .onAppear {
               listenToAuth()
           }
       }
    
    // MARK: - Firebase Auth Listener
    func listenToAuth() {
        Auth.auth().addStateDidChangeListener { _, firebaseUser in
            self.user = firebaseUser
        }
    }
    
    // MARK: - Confirm Order
    func confirmOrder() {
        let orderNo = generateOrderNumber()
        
        confirmationMessage = """
        ✅ Order Confirmed!
        
        Order No: \(orderNo)
        Total: \(cart.totalPrice, default: "%.2f") kr
        
        Thank you for shopping with us!
        """
        
        saveOrder()
        cart.items.removeAll()
        showAlert = true
    }
    
    // MARK: - Save Order to Firestore
    func saveOrder() {
        let orderNo = generateOrderNumber()
        
        let itemsData = cart.items.map { item in
            [
                "name": item.product.name,
                "price": item.product.price,
                "size": item.size.rawValue,
                "quantity": item.quantity,
                "imageUrl": item.product.imageUrl
            ]
        }
        
        let orderData: [String: Any] = [
            "orderNumber": orderNo,
            "userId": Auth.auth().currentUser?.uid ?? "",
            "total": Double(cart.totalPrice),
            "date": Timestamp(date: Date()),
            "items": itemsData
        ]
        
        Firestore.firestore()
            .collection("orders")
            .addDocument(data: orderData) { error in
                if let error = error {
                    print("❌ Save failed:", error)
                } else {
                    print("✅ New order saved")
                }
            }
    }
    
    func generateOrderNumber() -> String {
        "ORD-\(Int(Date().timeIntervalSince1970))"
    }
}





#Preview {
    CartView()
}*/
