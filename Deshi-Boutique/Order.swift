//
//  Order.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-02-03.
//

import Foundation

struct Order: Identifiable {
    let id: String
    let orderNumber: String
    let items: [CartItem]
    let total: Double
    let date: Date
}

