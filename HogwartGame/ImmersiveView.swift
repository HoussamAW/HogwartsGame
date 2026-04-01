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

    var body: some View {
        ZStack {
            RealityView { content in
                if let chamber = try? await ModelEntity(named: "Chamber") {
                    chamber.position = [0, -1.5, -10]
                    content.add(chamber)
                }

                let gameRoot = Entity()
                gameRoot.name = "GameRoot"
                content.add(gameRoot)
            }

            VStack {
                HStack {
                    Text("Score: \(game.score)")
                    Spacer()
                    Text("Temps: \(game.timeRemaining)")
                }
                .padding()
                Spacer()
            }
        }
        .preferredSurroundingsEffect(.colorMultiply(.black))
    }
}
