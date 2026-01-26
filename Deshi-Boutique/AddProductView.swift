//
//  AddProductView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct AddProductView: View {

    @State private var name = ""
    @State private var category = ""
    @State private var price = ""
    @State private var details = ""
    @State private var image: UIImage?

    @State private var showPicker = false
    @State private var isUploading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {

                Button {
                    showPicker = true
                } label: {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke()
                            .frame(height: 180)
                            .overlay(Text("Tap to select image"))
                    }
                }

                TextField("Product Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                TextField("Category", text: $category)
                    .textFieldStyle(.roundedBorder)

                TextField("Price", text: $price)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                TextField("Description", text: $details)
                    .textFieldStyle(.roundedBorder)

                Button(isUploading ? "Uploading..." : "Upload Product") {
                    upload()
                }
                .disabled(isUploading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Add Product")
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $image)
        }
    }

    func upload() {
        guard let image,
              let priceValue = Int(price) else {
            print("Uploading started")

            print("Missing data")
            
            print("Firestore saved")

            return
        }

        isUploading = true

        let ref = Storage.storage()
            .reference()
            .child("products/\(UUID().uuidString).jpg")

        ref.putData(image.jpegData(compressionQuality: 0.8)!) { _, error in
            if let error = error {
                print("Upload error:", error)
                isUploading = false
                return
            }

            ref.downloadURL { url, _ in
                guard let url else { return }

                Firestore.firestore()
                    .collection("products")
                    .addDocument(data: [
                        "name": name,
                        "category": category,
                        "price": priceValue,
                        "imageUrl": url.absoluteString,
                        "description": details
                    ]) { _ in
                        isUploading = false
                        clear()
                    }
            }
        }
    }

    func clear() {
        name = ""
        category = ""
        price = ""
        details = ""
        image = nil
    }
}

#Preview {
    AddProductView()
}
