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
}
