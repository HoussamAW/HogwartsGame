//
//  ImmersiveView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State private var game = GameState()
    @State private var gameRoot = Entity()

    var body: some View {
        ZStack {
            RealityView { content in
                gameRoot.name = "GameRoot"
                content.add(gameRoot)

                if let chamber = try? await ModelEntity(named: "Chamber") {
                    chamber.scale = [3,3,3]
                    chamber.position = [0, -1.5, -10]
                    content.add(chamber)
                }

                startTimer(game: game)
                startSpawning(into: gameRoot, game: game)
            }

            VStack {
                HStack {
                    Text("Score: \(game.score)")
                    Spacer()
                    Text("Temps: \(game.timeRemaining)")
                }
                .padding()

                Spacer()
                if game.isGameOver {
                    VStack(spacing: 12) {
                        Text("Game Over")
                            .font(.largeTitle)
                        Text("Score final \(game.score)")
                    }.padding()
                        .glassBackgroundEffect()
                }
            }
        }.gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded{ value in
                    handleTap(on: value.entity)
                }
        )
        .preferredSurroundingsEffect(.colorMultiply(.black))
    }
    private func handleTap(on entity: Entity) {
            guard !game.isGameOver else { return }
            guard entity.components[TargetComponent.self] != nil else { return }

            entity.removeFromParent()
            game.score += 1
        }
    }

