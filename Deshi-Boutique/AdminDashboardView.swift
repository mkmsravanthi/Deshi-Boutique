//
//  AdminDashboardView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//

import SwiftUI
import FirebaseAuth

struct AdminDashboardView: View {

    var body: some View {
        NavigationStack {
            List {

                NavigationLink("➕ Add Product") {
                    AddProductView()
                }

                NavigationLink("📦 Manage Products") {
                    ManageProductsView()
                }

                Button(role: .destructive) {
                    logout()
                } label: {
                    Text("🚪 Logout")
                }
            }
            .navigationTitle("Admin Dashboard")
            
        }
    }
    /*struct AddProductView: View {
        var body: some View {
            Text("Add Product Screen")
        }
    }*/

    func logout() {
        try? Auth.auth().signOut()
    }
}


#Preview {
    AdminDashboardView()
}
