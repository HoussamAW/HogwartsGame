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
    @State private var gameRoot = Entity()
    @State private var  hasStartedGameLoop = false
    
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
                
                if !hasStartedGameLoop {
                    hasStartedGameLoop = true
                    startTimer(game: game)
                    startSpawning(into: gameRoot, game: game)
                }
                
            }
            //           ScoreView(game: game)
            
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
        castSpell(at: entity)
    }
    
    //cast a spell at the tapped entity
    private func castSpell(at entity: Entity) {
        guard entity.components[TargetComponent.self] != nil else { return }

        let targetPosition = entity.position(relativeTo: gameRoot)
        let startPosition = SIMD3<Float>(0, 1.2, -0.8)

        spawnSpellFlash(at: startPosition, radius: 0.05)
        spawnSpellBeam(from: startPosition, to: targetPosition)
        spawnSpellFlash(at: targetPosition, radius: 0.09)

        entity.removeFromParent()
        game.score += 1
    }
    
    //spawns a short-lived visual spell effect at the given position
    private func spawnSpellEffect(at position: SIMD3<Float>) {
        let mesh = MeshResource.generateSphere(radius: 0.08)
        let material = SimpleMaterial(color: .cyan, isMetallic: false)
        let effect = ModelEntity(mesh: mesh, materials: [material])

        effect.position = position
        gameRoot.addChild(effect)

        Task {
            try? await Task.sleep(for: .milliseconds(180))
            effect.removeFromParent()
        }
    }
    
    private func spawnSpellFlash(at position: SIMD3<Float>, radius: Float) {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: .cyan, isMetallic: false)
        let flash = ModelEntity(mesh: mesh, materials: [material])

        flash.position = position
        gameRoot.addChild(flash)

        Task {
            try? await Task.sleep(for: .milliseconds(120))
            flash.removeFromParent()
        }
    }
    
    private func spawnSpellBeam(from start: SIMD3<Float>, to end: SIMD3<Float>) {
        let direction = end - start
        let length = simd_length(direction)

        guard length > 0.001 else { return }

        let mesh = MeshResource.generateBox(width: 0.012, height: 0.012, depth: length)
        let material = SimpleMaterial(color: .cyan, isMetallic: false)
        let beam = ModelEntity(mesh: mesh, materials: [material])

        beam.position = (start + end) / 2

        let forward = simd_normalize(direction)
        let baseForward = SIMD3<Float>(0, 0, 1)
        beam.orientation = simd_quatf(from: baseForward, to: forward)

        gameRoot.addChild(beam)

        Task {
            try? await Task.sleep(for: .milliseconds(150))
            beam.removeFromParent()
        }
    }
    
    private func restartGame() {
            for child in gameRoot.children {
                child.removeFromParent()
            }

            game.reset()
            hasStartedGameLoop = false
            hasStartedGameLoop = true
            startTimer(game: game)
            startSpawning(into: gameRoot, game: game)
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

