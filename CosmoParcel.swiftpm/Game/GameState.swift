//
//  GameState.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation
import SpriteKit

final class GameState: ObservableObject {
    // Public
    @Published private(set) var stage = GameStage.initialising {
        didSet { handleStageChanged(oldValue: oldValue) }
    }
    @Published var timeWarp = 1.0 / GameScaling.timeScalingVsSpriteKit {
        didSet { handleTimeWarpChanged() }
    }
    private let scene: GameScene
    private var rocket: Rocket?
    private var camera: SKCameraNode? { scene.camera }

    // MARK: Init

    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.rocket = entityManager.entities.first(where: { $0 is Rocket }) as? Rocket
        handleStageChanged(oldValue: .initialising)
        stage = .intro
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
    func handleStageChanged(oldValue: GameStage) {
        assert(oldValue.allowedStageTransitions.contains(stage))

        switch stage {
        case .initialising: handleStageChangedToInitialising()
        case .intro: handleStageChangedToIntro()
        case .positioning: handleStageChangedToPositioning()
        case .traversing: handleStageChangedToTraversing()
        }
    }

    func handleStageChangedToInitialising() {
        timeWarp = 0.0
        scene.touchesDelegate = nil
    }

    func handleStageChangedToIntro() {
        timeWarp = 1.0 / GameScaling.timeScalingVsSpriteKit * 1.2
        scene.touchesDelegate = nil

        let introDuration = 7.0
        let slowDownFactor = 0.9
        // Camera's initial scale on intro's start
        camera?.setScale(1.5)
        // Slows down time by slowDownFactor each second
        for delay in stride(from: 1.0, through: introDuration, by: 1.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) { [weak self] in
                self?.timeWarp *= slowDownFactor
                // This allows running camera animations in stable time
                self?.camera?.speed *= (1 / slowDownFactor)
            }
        }
        // Transitions to .positioning stage after intro ends
        DispatchQueue.main.asyncAfter(deadline: .now() + introDuration) { [weak self] in
            // Progresses to the next stage on completion of intro
            self?.stage = .positioning
            // Resets camera speed
            self?.camera?.speed = 1.0
        }
        // Camera zoom in on intro
        let zoomInAction = SKAction.scale(to: 1.0, duration: introDuration * 0.8)
        camera?.run(zoomInAction)
    }

    func handleStageChangedToPositioning() {
        camera?.setScale(1.0)
        timeWarp = 1.0 / GameScaling.timeScalingVsSpriteKit * 0.3
        scene.touchesDelegate = rocket?.component(ofType: LaunchPositioningComponent.self)
    }

    func handleStageChangedToTraversing() {
        timeWarp = 1.0 / GameScaling.timeScalingVsSpriteKit
        scene.touchesDelegate = nil

        guard let engine = rocket?.component(ofType: EngineComponent.self) else { assertionFailure(); return }
        engine.isOn = true
    }
}

// MARK: - Time warp manipulation private methods

private extension GameState {
    func handleTimeWarpChanged() {
        let spriteKitTime = timeWarp * GameScaling.timeScalingVsSpriteKit
        scene.isPaused = (timeWarp <= 0.0 + .leastNonzeroMagnitude)
        scene.speed = spriteKitTime
        scene.physicsWorld.speed = spriteKitTime
    }
}

// MARK: - GameStage

extension GameState {
    enum GameStage {
        case initialising
        /// Stage of the game when the scene is previewed to the player
        case intro
        /// Stage of the game when the player is positioning the rocket before the launch
        case positioning
        /// Stage of the game when the rocket is launched and traversing the space
        case traversing

        var allowedStageTransitions: [GameStage] {
            switch self {
            case .initialising: return [.intro, .initialising]
            case .intro: return [.positioning]
            case .positioning: return [.traversing]
            case .traversing: return []
            }
        }
    }
}
