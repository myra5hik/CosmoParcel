//
//  Rocket.swift
//  
//
//  Created by Alexander Tokarev on 12.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class Rocket: GKEntity {
    init(mass: Double, position: CGPoint? = nil, height: CGFloat? = nil, thrust: CGFloat) {
        super.init()
        // Sprite component
        let texture = SKTexture(imageNamed: "RocketShip")
        let ratio = texture.size().width / texture.size().height
        let height = height ?? 10
        let spriteComponent = SpriteComponent(
            texture: texture,
            size: .init(width: ratio * height, height: height),
            initialPosition: position ?? .init(x: 0, y: 0)
        )
        let node = spriteComponent.node
        node.zPosition = 1
        self.addComponent(spriteComponent)
        // Physics body
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody?.mass = mass
        // Engine
        let engineComponent = EngineComponent(thrust: thrust)
        self.addComponent(engineComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
