//
//  Product.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-02-02.
//

import Foundation

import Foundation

struct Product: Identifiable {
    let id: String
    let name: String
    let category: String
    let price: Double   // ✅ change to Double
    let imageUrl: String
    let details: String
}

