//
//  Target.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 02/04/2026.
//

import RealityKit

//create some sphere for the target
func makeTarget() -> Entity {
    let mesh = MeshResource.generateSphere(radius: 0.18)
    let material = SimpleMaterial()
    let target = ModelEntity(mesh: mesh, materials: [material])

    target.position = [
        Float.random(in: -2.0...2.0),
        Float.random(in: 0.8...2.2),
        Float.random(in: -6.0 ... -3.0)
    ]

    target.components.set(TargetComponent())
    target.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.18)]))
    target.components.set(InputTargetComponent())

    return target
}

func startTimer(game: GameState) {
    Task {
        while game.timeRemaining > 0 {
            try? await Task.sleep(for: .seconds(1))
            game.timeRemaining -= 1
        }
        game.isGameOver = true
    }
}

//spwan logic for the object
func startSpawning(into root: Entity, game: GameState) {
    Task {
        while !game.isGameOver {
            let target = makeTarget()
            root.addChild(target)
            
            Task {
                try? await Task.sleep(for: .seconds(3))
                if target.parent != nil {
                    target.removeFromParent()
                }
            }
            try? await Task.sleep(for: .seconds(1.5))
        }
    }
}
