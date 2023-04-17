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
    private let level: Level
    // State
    @State private var isPaused = true

    init(level: Level) {
        // Creates dependencies
        let scene = GameScene()
        self.scene = scene
        self.entityManager = EntityManager(scene: scene)
        self.level = level
        // Loads level
        level.load(into: scene, entityManager: entityManager)
        // Sets game state
        self.gameState = GameState(scene: scene, entityManager: entityManager)
    }

    var body: some View {
        ZStack {
            if isPaused {
                pauseOverlay
            } else {
                gamePlayView
            }
        }
        .onChange(of: isPaused) {
            guard $0 == false else { return }
            gameState.startGame()
            level.applyInitialPhysics()
        }
    }

    private var gamePlayView: some View {
        #if DEBUG
        let options: SpriteView.DebugOptions = [.showsDrawCount, .showsFPS, .showsNodeCount]
        #else
        let options: SpriteView.DebugOptions = []
        #endif

        return HStack {
            SpriteView(scene: scene, isPaused: isPaused, options: .ignoresSiblingOrder, debugOptions: options)
                .frame(minWidth: 300, minHeight: 300)
                .aspectRatio(1.0, contentMode: .fit)
            ControlPanelView(gameState: gameState)
                .frame(width: 300)
        }
    }

    private var pauseOverlay: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.systemGray5))
            Button("Start Level") {
                isPaused = false
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView(level: .tutorial())
    }
}
