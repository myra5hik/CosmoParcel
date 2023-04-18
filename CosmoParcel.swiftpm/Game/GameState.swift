//
//  GameState.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation
import SpriteKit

final class GameState: NSObject, ObservableObject {
    // Public
    @Published private(set) var stage = GameStage.notStarted {
        didSet { handleStageChanged(oldValue: oldValue) }
    }
    @Published var timeWarp = 1.0 / GameScaling.timeScalingVsSpriteKit {
        didSet { handleTimeWarpChanged() }
    }
    private let scene: GameScene
    private let rocket: Rocket?
    private let target: CosmicObject?
    private var camera: SKCameraNode? { scene.camera }

    // MARK: Init

    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.rocket = entityManager.entities.first(where: { $0 is Rocket }) as? Rocket
        self.target = entityManager.entities.first(where: {
            guard let object = $0 as? CosmicObject else { return false }
            let targetMask = ContactComponent.Mask.targetObject.rawValue
            return object.component(ofType: ContactComponent.self)?.ownMask == .some(targetMask)
        }) as? CosmicObject
        super.init()
        scene.physicsWorld.contactDelegate = self
        handleStageChanged(oldValue: .notStarted)
    }
}

// MARK: - Game stage manipulation public methods

extension GameState {
    func startGame() {
        stage = .intro
    }

    func launchRocket() {
        stage = .cruising
    }
}

// MARK: - Game stage manipulation private methods

private extension GameState {
    private enum TimewarpConfig {
        static let realTime = 1.0 / GameScaling.timeScalingVsSpriteKit

        static let introTimewarp = realTime * 1.2
        static let positioningTimewarp = realTime * 0.3
        static let traversingTimewarp = realTime
        static let targetReachedTimewarp = realTime * 0.3
    }

    func handleStageChanged(oldValue: GameStage) {
        assert(oldValue.allowedStageTransitions.contains(stage))

        switch stage {
        case .notStarted: handleStageChangedToInitialising()
        case .intro: handleStageChangedToIntro()
        case .positioning: handleStageChangedToPositioning()
        case .cruising: handleStageChangedToTraversing()
        case .targetReached: handleStageChangedToTargetReached()
        }

        print("Game stage moved to: \(stage)")
    }

    func handleStageChangedToInitialising() {
        timeWarp = 0.0
        scene.touchesDelegate = nil
    }

    func handleStageChangedToIntro() {
        timeWarp = TimewarpConfig.introTimewarp
        scene.touchesDelegate = nil

        let introDuration = 7.0
        let slowDownFactor = 0.9
        // Camera's initial scale on intro's start
        camera?.setScale(1.3)
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
        timeWarp = TimewarpConfig.positioningTimewarp
        scene.touchesDelegate = rocket?.component(ofType: LaunchPositioningComponent.self)
    }

    func handleStageChangedToTraversing() {
        timeWarp = TimewarpConfig.traversingTimewarp
        scene.touchesDelegate = nil

        guard let engine = rocket?.component(ofType: EngineComponent.self) else { assertionFailure(); return }
        engine.isOn = true
    }

    func handleStageChangedToTargetReached() {
        hideRealRocket()
        addFakeRocket()

        // Slows down time gradually
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.timeWarp *= 0.6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.timeWarp = TimewarpConfig.targetReachedTimewarp
        }
    }
}

// MARK: - Private misc

private extension GameState {
    /// Hides the real rocket, used when the user reaches the target
    func hideRealRocket() {
        guard
            let rocketNode = rocket?.component(ofType: SpriteComponent.self)?.node,
            let targetNode = target?.component(ofType: SpriteComponent.self)?.node
        else { assertionFailure(); return }
        // Turns off further gravity effects for the rocket
        rocketNode.physicsBody?.fieldBitMask = 0b0
        // Fades and removes
        let duration = 0.5
        let moveToCenter = SKAction.move(to: targetNode.position, duration: duration)
        let fade = SKAction.fadeOut(withDuration: duration)
        let remove = SKAction.removeFromParent()
        rocketNode.run(SKAction.sequence([SKAction.group([moveToCenter, fade]), remove]))
    }

    /// Adds a fake rocket, used when the user reaches the target
    func addFakeRocket() {
        guard
            let targetNode = target?.component(ofType: SpriteComponent.self)?.node,
            let realRocketNode = rocket?.component(ofType: SpriteComponent.self)?.node
        else { assertionFailure(); return }

        let fakeRocketNode = SKSpriteNode(texture: SKTexture(imageNamed: "RocketShip"))
        fakeRocketNode.size = realRocketNode.size
        // Puts the rocket behind the target object
        fakeRocketNode.position = .zero
        fakeRocketNode.zPosition = targetNode.zPosition - 1
        targetNode.addChild(fakeRocketNode)
        // Makes the rocket slide out from behind the target object
        let position = CGPoint(x: 0.0, y: targetNode.size.height / 2 + fakeRocketNode.size.height / 2)
        let action = SKAction.move(to: position, duration: 2.0)
        fakeRocketNode.run(action)
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

// MARK: - SKPhysicsContactDelegate protocol conformance

extension GameState: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        handleContact(contact)
    }

    private func handleContact(_ contact: SKPhysicsContact) {
        let categories = contactCategories(contact)
        if categories.contains(.rocket) { handleRocketContact(contact) }
    }

    private func handleRocketContact(_ contact: SKPhysicsContact) {
        let categories = contactCategories(contact)
        guard categories.contains(.rocket) else { assertionFailure(); return }

        if categories.contains(.targetObject) {
            // Ignores multiple contacts, sets new stage only once
            guard stage != .targetReached else { return }
            stage = .targetReached
        }
    }

    private func contactCategories(_ contact: SKPhysicsContact) -> [ContactComponent.Mask] {
        return [
            contact.bodyA.node?.physicsBody?.categoryBitMask,
            contact.bodyB.node?.physicsBody?.categoryBitMask
        ]
        .compactMap({ $0 })
        .compactMap(ContactComponent.Mask.init(rawValue:))
    }
}

// MARK: - GameStage

extension GameState {
    enum GameStage {
        /// Initial stage, which waits for startGame() call to start running
        case notStarted
        /// Stage of the game when the scene is previewed to the player
        case intro
        /// Stage of the game when the player is positioning the rocket before the launch
        case positioning
        /// Stage of the game when the rocket is launched and traversing the space
        case cruising
        /// Stage of the game when player successfully reached target object
        case targetReached

        var allowedStageTransitions: [GameStage] {
            switch self {
            case .notStarted: return [.intro, .notStarted]
            case .intro: return [.positioning]
            case .positioning: return [.cruising]
            case .cruising: return [.targetReached]
            case .targetReached: return []
            }
        }
    }
}
