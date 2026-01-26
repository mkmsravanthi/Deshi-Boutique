//
//  CartView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        NavigationStack {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(cartManager.cartItems) { product in
                                HomeProductCard(
                                    product: product,
                                    showCartButton: false,
                                    showFavoriteButton: true
                                )
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("My Cart")
                }
            }
        }
#Preview {
    CartView()
}
