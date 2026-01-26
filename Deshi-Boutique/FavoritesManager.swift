//
//  FavoritesManager.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favorites: [Product] = []

    func toggleFavorite(_ product: Product) {
        if let index = favorites.firstIndex(where: { $0.id == product.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(product)
        }
    }

    func isFavorite(_ product: Product) -> Bool {
        favorites.contains(where: { $0.id == product.id })
    }
}
