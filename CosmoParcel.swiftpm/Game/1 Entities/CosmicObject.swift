//
//  CosmicObject.swift
//  
//
//  Created by Alexander Tokarev on 06.04.2023.
//

import SpriteKit
import GameplayKit

final class CosmicObject: GKEntity {
    init(mass: Double, position: CGPoint? = nil, size: CGSize? = nil) {
        super.init()
        // Sprite component
        let spriteComponent = SpriteComponent(
            size: size,
            initialPosition: position ?? .init(x: 0, y: 0)
        )
        let node = spriteComponent.node
        self.addComponent(spriteComponent)
        // Animation component
        let atlas = SKTextureAtlas(named: "Planet1")
        let animationComponent = AnimationComponent(node: spriteComponent.node, atlas: atlas)
        self.addComponent(animationComponent)
        // Gravity component
        node.physicsBody = SKPhysicsBody(circleOfRadius: min(node.size.width, node.size.height) / 2)
        let gravityComponent = GravityComponent(mass: mass, node: node)
        self.addComponent(gravityComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
