//
//  WhishlistView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

struct WhishlistView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

        var body: some View {
            NavigationStack {
                        ScrollView {
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 16
                            ) {
                                ForEach(favoritesManager.favorites) { product in
                                    HomeProductCard(
                                        product: product,
                                        showCartButton: false,
                                        showFavoriteButton: true
                                    )
                                }
                            }
                            .padding()
                        }
                        .navigationTitle("Wishlist")
                    }
                }
            }

#Preview {
    WhishlistView()
}
