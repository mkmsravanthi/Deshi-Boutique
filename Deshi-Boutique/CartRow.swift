//
//  CartRow.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-02-12.
//

import SwiftUI

struct CartRow: View {
    let item: CartItem
    @EnvironmentObject var cart: CartManager

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: URL(string: item.product.imageUrl)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 90, height: 110)
            .clipped()
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.headline)

                //Text("Size: \(item.size.rawValue)")
                
                Picker("Size", selection: Binding(
                    get: { item.size },
                    set: { cart.update(item: item, newSize: $0) }
                )) {
                    ForEach(Size.allCases, id: \.self) { size in
                        Text(size.rawValue).tag(size)
                    }
                }
                 .pickerStyle(MenuPickerStyle())
                 .font(.subheadline)
                 .foregroundColor(.gray)

                Text("\(item.product.price, specifier: "%.2f") kr ")
                    .font(.headline)
                    .foregroundColor(.green)

                Stepper("Qty \(item.quantity)", value: Binding(
                    get: { item.quantity },
                    set: { cart.update(item: item, newQuantity: $0) }
                ), in: 1...10)
            }

            Spacer()

            Button {
                cart.remove(item: item)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

