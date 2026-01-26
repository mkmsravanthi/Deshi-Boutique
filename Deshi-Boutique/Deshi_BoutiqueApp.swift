//
//  Deshi_BoutiqueApp.swift
//  Deshi-Boutique
//
//  Created by K M Sravanthi Mangipudi on 2026-01-16.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct Deshi_BoutiqueApp: App {
    
    // 🔥 Connect AppDelegate
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()
    
   /* init() {
           FirebaseApp.configure()
       }*/
    var body: some Scene {
        WindowGroup {
                    RootView()
                        .environmentObject(cartManager)
                        .environmentObject(favoritesManager)
                }
    }
}

 /*import SwiftUI
 import FirebaseCore

 class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     FirebaseApp.configure()
     return true
   }
 }

 @main
 struct YourApp: App {
   // register app delegate for Firebase setup
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

   var body: some Scene {
     WindowGroup {
       NavigationView {
         ContentView()
       }
     }
   }
 }
 */
