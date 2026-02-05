//
//  OrderHistoryView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-02-04.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct OrderHistoryView: View {
    
    @State private var orders: [Order] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                if orders.isEmpty {
                    Text("No orders yet")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }
                
                ForEach(orders) { order in
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack {
                            Text("Order \(order.orderNumber)")
                                .font(.headline)
                            Spacer()
                            Text(order.date, style: .date)
                                .font(.caption)
                        }
                        
                        Text("Total: \(order.total, specifier: "%.2f") kr")
                        
                        
                        ForEach(order.items) { item in
                            HStack {
                                
                                AsyncImage(url: URL(string: item.product.imageUrl)) { img in
                                    img.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(item.product.name)
                                    Text("Size: \(item.size.rawValue)")
                                    Text("Qty: \(item.quantity)")
                                }
                                
                                Spacer()
                                
                                Text(" \(item.product.price, specifier: "%.2f") kr")
                                
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14)
                }
            }
            .padding()
        }
        .navigationTitle("My Orders")
        .onAppear {
            fetchOrders()
        }
    }
    
    // 🔥 Correct mapping to CartItem
    
   

    func fetchOrders() {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No logged in user")
            return
        }

        Firestore.firestore()
            .collection("orders")
            .whereField("userId", isEqualTo: uid)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in

                if let error = error {
                    print("❌ Failed to fetch orders:", error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No documents")
                    return
                }

                print("✅ Orders fetched:", documents.count)

                orders = documents.compactMap { doc in
                    let data = doc.data()

                    let itemsData = data["items"] as? [[String: Any]] ?? []

                    let cartItems = itemsData.map { item in
                        CartItem(
                            product: Product(
                                id: UUID().uuidString,
                                name: item["name"] as? String ?? "",
                                category: "",
                                price: (item["price"] as? Double) ?? Double(item["price"] as? Int ?? 0),
                                imageUrl: item["imageUrl"] as? String ?? "",
                                details: ""
                            ),
                            size: Size(rawValue: item["size"] as? String ?? "M") ?? .M,
                            quantity: item["quantity"] as? Int ?? 1
                        )
                    }

                    return Order(
                        id: doc.documentID,
                        orderNumber: data["orderNumber"] as? String ?? "",
                        items: cartItems,
                        total: data["total"] as? Double ?? 0,
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }
            }
    }

}
