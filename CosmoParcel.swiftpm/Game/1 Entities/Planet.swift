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
        let spriteComponent = SpriteComponent(color: .blue, size: .init(width: 20, height: 20))
        self.addComponent(spriteComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
