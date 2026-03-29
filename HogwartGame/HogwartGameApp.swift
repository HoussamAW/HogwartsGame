//
//  HogwartGameApp.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI

@main
struct HogwartGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.plain)
        
        ImmersiveSpace(id: "GameImmersiveView") {
            ImmersiveView()
        }
    }
}
