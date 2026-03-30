//
//  HogwartGameApp.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI

@main
struct HogwartGameApp: App {
    @State private var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environment(appModel)
        }
        .windowStyle(.plain)
        
        ImmersiveSpace(id: "GameImmersiveView") {
            ImmersiveView()
                .environment(appModel)
               
        }
    }
}
