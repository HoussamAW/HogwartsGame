//
//  ImmersiveView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI
import RealityKit
import simd

struct ImmersiveView: View {
    @State private var game = GameState()
    @State private var muse = MuseController()
    @State private var gameRoot = Entity()

    var body: some View {
        ZStack {
            RealityView { content in
                gameRoot.name = "GameRoot"
                content.add(gameRoot)

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
            muse.onPrimaryButtonPressed = {
                castSpell()
            }
            muse.start()
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

           if let target = gameRoot.children.first(where: { $0.components[TargetComponent.self] != nil }) {
               target.removeFromParent()
               game.score += 1
           }
       }
    
    }




//import SwiftUI
//import RealityKit
//
//struct ImmersiveView: View {
//    @State private var game = GameState()
//    @State private var gameRoot = Entity()
//
//    var body: some View {
//        RealityView { content in
//            gameRoot.name = "GameRoot"
//            content.add(gameRoot)
//            content.add(makeHUD())
//
//            if let chamber = try? await ModelEntity(named: "Chamber") {
//                chamber.scale = [5, 5, 5]
//                chamber.position = [644, 625, 400]
//                chamber.orientation = simd_quatf(angle: .pi / 8, axis: [0, 4, 0])
//                content.add(chamber)
//            }
//
//            startTimer(game: game)
//            startSpawning(into: gameRoot, game: game)
//        } update: { content in
//            if let text = content.entities.first?.findEntity(named: "HUDText") as? ModelEntity {
//                text.model?.mesh = .generateText(
//                    "Score: \(game.score)   Temps: \(game.timeRemaining)",
//                    extrusionDepth: 0.002,
//                    font: .systemFont(ofSize: 0.08, weight: .bold),
//                    containerFrame: .zero,
//                    alignment: .center,
//                    lineBreakMode: .byWordWrapping
//                )
//            }
//        }
//        .gesture(
//            TapGesture()
//                .targetedToAnyEntity()
//                .onEnded { value in
//                    if value.entity.components[TargetComponent.self] != nil {
//                        value.entity.removeFromParent()
//                        game.score += 1
//                    }
//                }
//        )
//    }
//
//    func makeHUD() -> Entity {
//        let anchor = AnchorEntity(.head)
//        anchor.position = [0, -0.08, -1.1]
//
//        let box = ModelEntity(
//            mesh: .generateBox(width: 0.9, height: 0.18, depth: 0.01),
//            materials: [SimpleMaterial(color: .black.withAlphaComponent(0.75), isMetallic: false)]
//        )
//
//        let text = ModelEntity(
//            mesh: .generateText(
//                "Score: 0   Temps: 30",
//                extrusionDepth: 0.002,
//                font: .systemFont(ofSize: 0.08, weight: .bold),
//                containerFrame: .zero,
//                alignment: .center,
//                lineBreakMode: .byWordWrapping
//            ),
//            materials: [SimpleMaterial(color: .white, isMetallic: false)]
//        )
//
//        text.name = "HUDText"
//        text.position = [-0.38, -0.03, 0.01]
//        anchor.addChild(box)
//        anchor.addChild(text)
//
//        return anchor
//    }
//}

