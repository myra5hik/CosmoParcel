//
//  GameplayView.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import SwiftUI
import SpriteKit

struct GameplayView: View {
    // Public
    private(set) var gameState: GameState
    // Private
    private let scene: GameScene
    private let entityManager: EntityManager

    init(level: Level) {
        // Creates dependencies
        let scene = GameScene()
        self.scene = scene
        self.entityManager = EntityManager(scene: scene)
        // Loads level
        level.load(into: scene, entityManager: entityManager)
        // Sets game state
        self.gameState = GameState(scene: scene, entityManager: entityManager)
    }

    var body: some View {
        HStack {
            SKSceneView(scene: scene)
                .aspectRatio(1.0, contentMode: .fit)
            ControlPanelView(gameState: gameState)
                .layoutPriority(1)
        }
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView(level: .tutorial)
    }
}
