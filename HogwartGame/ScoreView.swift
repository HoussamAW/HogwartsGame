//
//  ScoreView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 02/04/2026.
//

import SwiftUI

struct ScoreView: View {
    let game: GameState
    var body: some View {
        VStack {
            HStack(spacing: 24) {
                Text("Score: \(game.score)")
                Text("Temps: \(game.timeRemaining)")
            }
            .font(.system(size: 300))
            .bold()
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .glassBackgroundEffect()
            .offset(y:-140)
            

            Spacer(minLength: 0)
            if game.isGameOver {
                VStack(spacing: 12) {
                    Text("Game Over")
                        .font(.largeTitle)
                    Text("Score final \(game.score)")
                }.padding()
                    .glassBackgroundEffect()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ScoreView(game: GameState())
}
