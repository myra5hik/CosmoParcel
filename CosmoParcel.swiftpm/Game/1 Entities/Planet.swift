//
//  Planet.swift
//  
//
//  Created by Alexander Tokarev on 06.04.2023.
//

import SpriteKit
import GameplayKit

final class Planet: GKEntity {
    override init() {
        super.init()
        // Sprite component
        let spriteComponent = SpriteComponent(initialPosition: .init(x: 0.5, y: 0.5))
        self.addComponent(spriteComponent)
        // Animation component
        let atlas = SKTextureAtlas(named: "Planet1")
        let animationComponent = AnimationComponent(node: spriteComponent.node, atlas: atlas)
        self.addComponent(animationComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
