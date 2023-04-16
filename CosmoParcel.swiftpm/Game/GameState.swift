//
//  GameState.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation

final class GameState: ObservableObject {
    // Public
    @Published private(set) var stage = GameStage.positioning {
        didSet { handleStageChanged() }
    }
    // Private
    private var rocket: Rocket?
    // Dependencies
    private let scene: GameScene

    // MARK: Init

    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.rocket = entityManager.entities.first(where: { $0 is Rocket }) as? Rocket
        handleStageChanged()
    }
}

// MARK: - Game stage manipulation public methods

extension GameState {
    func launchRocket() {
        stage = .traversing
    }
}

// MARK: - Game stage manipulation private methods

private extension GameState {
    func handleStageChanged() {
        switch stage {
        case .positioning: handleStageChangedToPositioning()
        case .traversing: handleStageChangedToTraversing()
        }
    }

    func handleStageChangedToPositioning() {
        scene.isPaused = true
        scene.speed = 0.0
        scene.physicsWorld.speed = 0.0
        scene.touchesDelegate = rocket?.component(ofType: LaunchPositioningComponent.self)
    }

    func handleStageChangedToTraversing() {
        scene.isPaused = false
        scene.speed = 1.0
        scene.physicsWorld.speed = 1.0
        scene.touchesDelegate = nil

        guard let engine = rocket?.component(ofType: EngineComponent.self) else { assertionFailure(); return }
        engine.isOn = true
    }
}

// MARK: - GameStage

extension GameState {
    enum GameStage {
        /// Stage of the game when the player is positioning the rocket before the launch
        case positioning
        /// Stage of the game when the rocket is launched and traversing the space
        case traversing
    }
}
