//
//  ImmersiveView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI
import RealityKit
import ARKit
import simd

struct ImmersiveView: View {
    @State private var game = GameState()
    @State private var muse = MuseController()
    @State private var gameRoot = Entity()
    @State private var spatialTrackingSession = SpatialTrackingSession()
    @State private var didConfigureMuseTracking = false

    var body: some View {
        ZStack {
            RealityView { content in
                gameRoot.name = "GameRoot"
                content.add(gameRoot)
                muse.rootEntity = gameRoot

                if let chamber = try? await ModelEntity(named: "Chamber") {
                    chamber.scale = [5, 5, 5]
                    chamber.position = [644, 625, 400]
                    chamber.orientation = simd_quatf(angle: .pi / 8, axis: [0, 4, 0])
                    content.add(chamber)
                }

                startTimer(game: game)
                startSpawning(into: gameRoot, game: game)
               
            }
//           ScoreView(game: game)
         
        }.gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded{ value in
                    handleTap(on: value.entity)
                }
        )
        .task {
            muse.rootEntity = gameRoot
            muse.onPrimaryButtonPressed = {
                Task { @MainActor in
                    castSpell()
                }
            }
            muse.start()
        }
        .task {
            guard !didConfigureMuseTracking else { return }
            didConfigureMuseTracking = true

            let configuration = SpatialTrackingSession.Configuration(tracking: [.accessory])
            await spatialTrackingSession.run(configuration)
        }
        .preferredSurroundingsEffect(.colorMultiply(.black))
    }
    
    
    private func handleTap(on entity: Entity) {
        guard !game.isGameOver else { return }
        guard entity.components[TargetComponent.self] != nil else { return }

        entity.removeFromParent()
        game.score += 1
    }

    
    private func castSpell() {
        guard !game.isGameOver else { return }
        guard let wandTip = muse.wandTip else { return }
        guard let direction = muse.fireDirection() else { return }
        guard let scene = gameRoot.scene else { return }

        let start = wandTip.position(relativeTo: nil)
        let normalizedDirection = simd_normalize(direction)
        let end = start + normalizedDirection * 20

        let hits = scene.raycast(
            from: start,
            to: end,
            query: .nearest,
            mask: .default,
            relativeTo: nil
        )

        guard let hit = hits.first else { return }
        let hitEntity = hit.entity

        guard hitEntity.components[TargetComponent.self] != nil else { return }

        hitEntity.removeFromParent()
        game.score += 1
    }

}


