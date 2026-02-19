//
//  MainTabView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-22.
//

import SwiftUI

struct MainTabView: View {
    
    


    var body: some View {
        NavigationStack {
            TabView {
                
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                WhishlistView()
                    .tabItem {
                        Label("Wishlist", systemImage: "heart")
                    }
                
                CartView()
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            
        }
    }
}
