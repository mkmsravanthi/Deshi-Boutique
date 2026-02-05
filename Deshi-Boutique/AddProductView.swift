//
//  AddProductView.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-20.
//


import SwiftUI
import PhotosUI

struct AddProductView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var statusMessage = ""
    
    let backendURL = "http://192.168.68.61:3000/upload" // Replace with your server URL
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(Text("No Image Selected"))
            }
            
            PhotosPicker("Select Image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) { newItem in
                    if let item = newItem {
                        loadImage(item: item)
                    }
                }
            
            Button("Upload to GitHub") {
                if let image = selectedImage {
                    uploadToBackend(image: image)
                }
            }
            .disabled(selectedImage == nil)
            
            Text(statusMessage)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
    }
    
    func loadImage(item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data?):
                DispatchQueue.main.async {
                    self.selectedImage = UIImage(data: data)
                }
            case .success(nil):
                print("No data found")
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
    
    func uploadToBackend(image: UIImage) {
        
        guard let url = URL(string: backendURL) else {
            print("❌ Invalid backend URL")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Could not convert image")
            return
        }
        
        var request = URLRequest(url: url)
        print("url:", url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        statusMessage = "Uploading..."
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    statusMessage = "❌ \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    statusMessage = "❌ No response from server"
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let url = json["url"] as? String {
                    statusMessage = "✅ Uploaded!"
                    
                } else {
                    statusMessage = "❌ Upload failed"
                    print(String(data: data, encoding: .utf8) ?? "")
                }
            }
        }.resume()
    }
}


/*import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct AddProductView: View {

    @State private var name = ""
    @State private var category = ""
    @State private var price = ""
    @State private var details = ""
    @State private var image: UIImage?

    @State private var showPicker = false
    @State private var isUploading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {

                Button {
                    showPicker = true
                } label: {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke()
                            .frame(height: 180)
                            .overlay(Text("Tap to select image"))
                    }
                }

                TextField("Product Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                TextField("Category", text: $category)
                    .textFieldStyle(.roundedBorder)

                TextField("Price", text: $price)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                TextField("Description", text: $details)
                    .textFieldStyle(.roundedBorder)

                Button(isUploading ? "Uploading..." : "Upload Product") {
                    upload()
                }
                .disabled(isUploading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Add Product")
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $image)
        }
    }

    func upload() {
        guard let image,
              let priceValue = Int(price) else {
            print("Uploading started")

            print("Missing data")
            
            print("Firestore saved")

            return
        }

        isUploading = true

        let ref = Storage.storage()
            .reference()
            .child("products/\(UUID().uuidString).jpg")

        ref.putData(image.jpegData(compressionQuality: 0.8)!) { _, error in
            if let error = error {
                print("Upload error:", error)
                isUploading = false
                return
            }

            ref.downloadURL { url, _ in
                guard let url else { return }

                Firestore.firestore()
                    .collection("products")
                    .addDocument(data: [
                        "name": name,
                        "category": category,
                        "price": priceValue,
                        "imageUrl": url.absoluteString,
                        "description": details
                    ]) { _ in
                        isUploading = false
                        clear()
                    }
            }
        }
    }

    func clear() {
        name = ""
        category = ""
        price = ""
        details = ""
        image = nil
    }
}

#Preview {
    AddProductView()
}
*/
