//
//  CartManager.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    
    func add(product: Product, size: Size) {
        if let index = items.firstIndex(where: {
            $0.product.id == product.id && $0.size == size
        }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, size: size, quantity: 1))
        }
        print("Cart items now: \(items.map { "\($0.product.name) x\($0.quantity)" })")
        }

    func update(item: CartItem, newSize: Size? = nil, newQuantity: Int? = nil) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if let newSize = newSize { items[index].size = newSize }
        if let newQuantity = newQuantity { items[index].quantity = newQuantity }
    }

    func remove(item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    var totalPrice: Double {
        items.reduce(0.0) { $0 + $1.product.price * Double($1.quantity) }
    }
}

// MARK: - Cart Models

enum Size: String, CaseIterable {
    case S, M, L
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var size: Size
    var quantity: Int
}

// MARK: - Size Picker View

struct SizePicker: View {
    @Binding var selectedSize: Size

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Size.allCases, id: \.self) { size in
                Button(size.rawValue) {
                    selectedSize = size
                }
                .padding(6)
                .background(selectedSize == size ? Color.black : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(6)
            }
        }
    }
}
