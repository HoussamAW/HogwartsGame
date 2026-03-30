//
//  Test.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 30/03/2026.
//

import SwiftUI

struct LaunchView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Button("Enter") {
                Task {
                    await openImmersiveIfNeeded()
                }
            }
            .frame(width: 220)
            .padding()
            .background(Color.orange.opacity(0.3))
            .glassBackgroundEffect()
            .offset(y: -180)
            .buttonStyle(.plain)
        }
        .task {
            await openImmersiveIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            Task {
                if newPhase == .active {
                    await openImmersiveIfNeeded()
                } else {
                    await closeImmersiveIfNeeded()
                }
            }
        }
    }

    private func openImmersiveIfNeeded() async {
        guard !appModel.immersiveIsOpen else { return }

        let result = await openImmersiveSpace(id: "GameImmersiveView")

        if case .opened = result {
            appModel.immersiveIsOpen = true
        } else {
            appModel.immersiveIsOpen = false
        }
    }

    private func closeImmersiveIfNeeded() async {
        guard appModel.immersiveIsOpen else { return }

        await dismissImmersiveSpace()
        appModel.immersiveIsOpen = false
    }
}
