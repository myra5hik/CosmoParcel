//
//  GameScene.swift
//  
//
//  Created by Alexander Tokarev on 07.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    // State
    private var lastUpdate = 0.0
    // Systems
    private(set) lazy var systems: [GKComponentSystem] = {
        let engineSystem = GKComponentSystem(componentClass: EngineComponent.self)
        return [engineSystem]
    }()

    override init() {
        super.init(size: .init(width: 1000, height: 1000))
        physicsWorld.gravity = .zero
        physicsWorld.speed = 0
        self.isPaused = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastUpdate
        lastUpdate = currentTime
        for system in systems {
            system.update(deltaTime: delta)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let _ = touches.first else { return }
        self.isPaused = false
        physicsWorld.speed = 1
    }
}
