//
//  ContentView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-16.


import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ContentView: View {

    @State private var products: [Product] = []
    @State private var searchText = ""
  
    
    let categories = ["Sarees", "Kids", "Ornaments"]

    var body: some View {
        NavigationStack {
            
            ZStack {
                // 🔵 Background
                LinearGradient(
                    colors: [Color(red: 10/255, green: 25/255, blue: 60/255),
                             Color(red: 20/255, green: 45/255, blue: 90/255)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // 🔍 Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.8))

                            TextField("Search", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.7))
                        .cornerRadius(30)
                        .padding(.horizontal)
                        
                        .navigationTitle("Boutique")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    try? Auth.auth().signOut()
                                } label: {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                }
                            }
                        }

                        // 📂 Categories
                        Text("Categories:")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding(.horizontal)

                        ForEach(categories, id: \.self) { category in
                            categorySection(title: category)
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            fetchProducts()
        }
    }

    // MARK: - Category Section
    @ViewBuilder
    func categorySection(title: String) -> some View {
        let items = filteredProducts(for: title)

        if !items.isEmpty {
            VStack(alignment: .leading) {

                Text("\(title):")
                    .font(.title3)
                    .foregroundColor(.yellow)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(items) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                HomeProductCard(product: product)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - Filter Products
    
    func filteredProducts(for category: String) -> [Product] {
        products.filter { product in
            let matchesCategory =
                product.category
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased() ==
                category.lowercased()
            
            print("Fetched:", products.count)


            let matchesSearch =
                searchText.isEmpty ||
                product.name.lowercased().contains(searchText.lowercased())

            return matchesCategory && matchesSearch
        }
    }


    
    /*func filteredProducts(for category: String) -> [Product] {
        products.filter {
            $0.category.lowercased() == category.lowercased() &&
            (searchText.isEmpty ||
             $0.name.lowercased().contains(searchText.lowercased()))
        }
    }*/

    // MARK: - Fetch Products
    func fetchProducts() {
        Firestore.firestore()
            .collection("products")
            .getDocuments { snapshot, _ in

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.products = documents.map { doc in
                        let data = doc.data()
                        print("Fetched products:", self.products)

                        return Product(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            category: data["category"] as? String ?? "",
                            price: Double(data["price"] as? Int ?? 0),
                            imageUrl: data["imageUrl"] as? String ?? "",
                            details: data["description"] as? String ?? ""
                        )
                    }
                }
            }
    }
}







/*import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: - Product Model
struct Product: Identifiable {
    let id: String
    let name: String
    let category: String
    let price: Int
    let imageUrl: String
    let details: String
}

// MARK: - Home View
struct ContentView: View {

    @State private var products: [Product] = []
    @State private var searchText = ""

    let categories = ["Sarees", "Kids", "Ornaments"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 🔍 Search Bar
                    TextField("Search products", text: $searchText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // 🏷 Categories
                    ForEach(categories, id: \.self) { category in
                        let items = filteredProducts(for: category)

                        if !items.isEmpty {
                            VStack(alignment: .leading) {

                                Text(category)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(items) { product in
                                            NavigationLink {
                                                ProductDetailView(product: product)
                                            } label: {
                                                ProductDetailView(product: product)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Boutique")
            .toolbar {
                Button("Logout") {
                    logout()
                }
            }
        }
        .onAppear {
            fetchProducts()
        }
    }

    // MARK: - Filter Products
    func filteredProducts(for category: String) -> [Product] {
        products.filter {
            $0.category.lowercased() == category.lowercased() &&
            (searchText.isEmpty ||
             $0.name.lowercased().contains(searchText.lowercased()))
        }
    }

    // MARK: - Fetch Products
    func fetchProducts() {
        Firestore.firestore()
            .collection("products")
            .getDocuments { snapshot, _ in

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.products = documents.map { doc in
                        let data = doc.data()

                        return Product(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            category: data["category"] as? String ?? "",
                            price: data["price"] as? Int ?? 0,
                            imageUrl: data["imageUrl"] as? String ?? "",
                            details: data["description"] as? String ?? ""
                        )
                    }
                }
            }
    }

    // MARK: - Logout
    func logout() {
        try? Auth.auth().signOut()
    }
}





#Preview {
    ContentView()
}*/
