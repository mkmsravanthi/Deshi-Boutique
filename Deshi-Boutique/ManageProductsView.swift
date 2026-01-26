//
//  ManageProductsView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI
import FirebaseFirestore

struct ManageProductsView: View {

    @State private var products: [Product] = []

    var body: some View {
        List {
            ForEach(products) { product in
                HStack {
                    AsyncImage(url: URL(string: product.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)

                        Text("kr\(product.price)")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: deleteProduct)
        }
        .navigationTitle("Manage Products")
        .onAppear {
            fetchProducts()
        }
    }

    // MARK: - Fetch Products
    func fetchProducts() {
        Firestore.firestore()
            .collection("products")
            .getDocuments { snapshot, error in

                guard let documents = snapshot?.documents else { return }

                self.products = documents.map { doc in
                    let data = doc.data()

                    return Product(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        price: data["price"] as? Int ?? 0,
                        imageUrl: data["imageUrl"] as? String ?? "",
                        details: data["description"] as? String ?? "" // ✅ FIX
                    )
                }
            }
    }

    // MARK: - Delete Product
    func deleteProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]

            Firestore.firestore()
                .collection("products")
                .document(product.id)
                .delete()

            products.remove(at: index)
        }
    }
}


#Preview {
    ManageProductsView()
}
