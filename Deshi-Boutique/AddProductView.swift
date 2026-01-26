//
//  AddProductView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI
import FirebaseFirestore

struct AddProductView: View {

    @State private var name = ""
    @State private var category = ""
    @State private var price = ""
    @State private var imageUrl = ""
    @State private var description = ""

    @Environment(\.dismiss) var dismiss

    let categories = ["Sarees", "Kids", "Ornaments"]

    var body: some View {
        Form {
            Section(header: Text("Product Details")) {

                TextField("Product Name", text: $name)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Price", text: $price)
                    .keyboardType(.numberPad)

                TextField("Image URL (public)", text: $imageUrl)

                TextField("Description", text: $description)
            }

            Button("Save Product") {
                saveProduct()
            }
        }
        .navigationTitle("Add Product")
    }

    // MARK: - Save Product to Firestore
    func saveProduct() {

        guard !name.isEmpty,
              !price.isEmpty,
              !imageUrl.isEmpty else {
            return
        }

        let productData: [String: Any] = [
            "name": name,
            "category": category,
            "price": Int(price) ?? 0,
            "imageUrl": imageUrl,
            "description": description
        ]

        Firestore.firestore()
            .collection("products")
            .addDocument(data: productData) { error in
                if error == nil {
                    dismiss()
                }
            }
    }
}


#Preview {
    AddProductView()
}
