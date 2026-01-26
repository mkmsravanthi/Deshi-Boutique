//
//  CartManager.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

class CartManager: ObservableObject {
    @Published var cartItems: [Product] = []

    func addToCart(_ product: Product) {
        if !cartItems.contains(where: { $0.id == product.id }) {
            cartItems.append(product)
        }
    }
}
