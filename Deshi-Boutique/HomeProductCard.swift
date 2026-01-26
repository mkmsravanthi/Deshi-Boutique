//
//  HomeProductCard.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

struct HomeProductCard: View {
    let product: Product

    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    var showCartButton: Bool = true
    var showFavoriteButton: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack(alignment: .topTrailing) {

                AsyncImage(url: URL(string: product.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 160)
                .clipped()
                .cornerRadius(12)

                if showFavoriteButton {
                    Button {
                        favoritesManager.toggleFavorite(product)
                    } label: {
                        Image(systemName:
                            favoritesManager.isFavorite(product)
                            ? "heart.fill"
                            : "heart"
                        )
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                    }
                    .padding(6)
                }
            }

            Text(product.name)
                .font(.headline)
                .lineLimit(1)

            Text("kr\(product.price)")
                .foregroundColor(.gray)

            if showCartButton {
                Button {
                    cartManager.addToCart(product)
                } label: {
                    Text("Add to Cart")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                .onAppear{
                    print("CartManager:", $cartManager.cartItems.count)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(radius: 4)
    }
}

#Preview {
    HomeProductCard(product: .mock)
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
}


