//
//  CartView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CartView: View {
    @EnvironmentObject var cart: CartManager

    @State private var showAlert = false
    @State private var confirmationMessage = ""

    var body: some View {
        VStack(spacing: 16) {

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(cart.items) { item in
                        CartRow(item: item)
                    }
                }
                .padding()
            }

            // TOTAL + BUTTONS
            VStack(spacing: 12) {

                HStack {
                    Text("Total")
                        .font(.headline)

                    Spacer()

                    Text("\(cart.totalPrice, specifier: "%.2f") kr")
                        .font(.title2)
                        .fontWeight(.bold)
                }

                Button {
                    saveOrder()
                    cart.items.removeAll()
                    showAlert = true
                } label: {
                    Text("Confirm & Proceed")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .font(.headline)
                }


                NavigationLink(destination: OrderHistoryView()) {
                    Text("View My Orders")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(radius: 5)
        }
        .navigationTitle("My Cart")
        .alert("Order Status", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }

    // MARK: - Actions

    func confirmOrder() {
        let orderNo = generateOrderNumber()

        confirmationMessage = """
        ✅ Order Confirmed!

        Order No: \(orderNo)

        Total:  \(cart.totalPrice, default: "%.2f") kr

        You will receive email confirmation shortly.
        """

        saveOrder()
        cart.items.removeAll()
        showAlert = true
    }

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


struct CartRow: View {
    let item: CartItem
    @EnvironmentObject var cart: CartManager

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: URL(string: item.product.imageUrl)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 90, height: 110)
            .clipped()
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.headline)

                //Text("Size: \(item.size.rawValue)")
                
                Picker("Size", selection: Binding(
                    get: { item.size },
                    set: { cart.update(item: item, newSize: $0) }
                )) {
                    ForEach(Size.allCases, id: \.self) { size in
                        Text(size.rawValue).tag(size)
                    }
                }
                 .pickerStyle(MenuPickerStyle())
                 .font(.subheadline)
                 .foregroundColor(.gray)

                Text("\(item.product.price, specifier: "%.2f") kr ")
                    .font(.headline)
                    .foregroundColor(.green)

                Stepper("Qty \(item.quantity)", value: Binding(
                    get: { item.quantity },
                    set: { cart.update(item: item, newQuantity: $0) }
                ), in: 1...10)
            }

            Spacer()

            Button {
                cart.remove(item: item)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}


#Preview {
    CartView()
}
