//
//  Test.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 30/03/2026.
//

import SwiftUI

struct LaunchView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Button {
                Task {
//                    guard !appModel.immersiveIsOpen else { return }
                    let result = await openImmersiveSpace(id: "GameImmersive")

                    if result == .opened {
                        appModel.immersiveIsOpen = true
                        dismissWindow(id: "launch")
                    }
                }
            } label: {
                Text("Enter")
                    .frame(width: 220)
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .glassBackgroundEffect()
            }
            .offset(y: -180)
            .buttonStyle(.plain)
        }
        .onChange(of: scenePhase) { _, newPhase in
            Task {
                if newPhase == .active {
                    await appModel.openImmersiveIfNeeded()
                } else {
                    await appModel.closeImmersiveIfNeeded()
                }
            }
        }
    }
}


