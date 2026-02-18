//
//  ProductDetailView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product
    
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    @State private var selectedSize: Size = .M

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // 🖼 Product Image
                AsyncImage(url: URL(string: product.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .clipped()

                // 🏷 Product Name
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // 💰 Price
                Text("kr \(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.horizontal)

                // 📏 Size Selection
                Text("Select Size")
                    .font(.headline)
                    .padding(.horizontal)

                SizePicker(selectedSize: $selectedSize)
                    .padding(.horizontal)

                // 🛒 Add to Cart
                Button {
                    cartManager.add(product: product, size: selectedSize)
                } label: {
                    Text("Add to Cart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductRow(product: product)
                }


                // 📝 Description
                Text("Product Description")
                    .font(.headline)
                    .padding(.horizontal)

                Text(product.details)
                    .padding(.horizontal)
                    .foregroundColor(.gray)

                Spacer()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}



extension Product {
    static let mock = Product(
        id: "1",
        name: "Handloom Saree",
        category: "Sarees",
        price: 249,
        imageUrl: "https://example.com/image.jpg",
        details: "Beautiful handwoven saree made with pure cotton."
    )
}
struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("kr \(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}



#Preview {
    let cartManager = CartManager()
    let favoritesManager = FavoritesManager()

    NavigationStack {
        ProductDetailView(product: .mock)
            .environmentObject(cartManager)
            .environmentObject(favoritesManager)
    }
}



