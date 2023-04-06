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
        let atlas = SKTextureAtlas(named: "Planet1")
        let texture = atlas.textureNamed("Planet1-0")
        let spriteComponent = SpriteComponent(
            texture: texture,
            size: .init(width: 0.5, height: 0.5),
            initialPosition: .init(x: 0.5, y: 0.5)
        )
        self.addComponent(spriteComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
