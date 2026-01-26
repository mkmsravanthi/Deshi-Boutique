//
//  ProductDetailView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product   // Product passed from home screen
    
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    
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
                Text("kr\(product.price)")
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.horizontal)

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


#Preview {
    NavigationStack {
        ProductDetailView(product: .mock)
    }
    .environmentObject(CartManager())
    .environmentObject(FavoritesManager())
}


