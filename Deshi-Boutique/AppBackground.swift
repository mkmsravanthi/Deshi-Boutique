//
//  AppBackground.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 8/255, green: 25/255, blue: 64/255),
                Color(red: 15/255, green: 40/255, blue: 90/255)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

