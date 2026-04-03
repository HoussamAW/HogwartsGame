//
//  GameState.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 02/04/2026.
//

import SwiftUI
import RealityKit
import Observation

@MainActor
@Observable
final class GameState {
    var score = 0
    var timeRemaining = 30
    var isGameOver = false
    
    
    func reset() {
            score = 0
            timeRemaining = 30
            isGameOver = false
        }
    
}
