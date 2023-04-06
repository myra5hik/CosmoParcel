//
//  SpriteComponent.swift
//  
//
//  Created by Alexander Tokarev on 06.04.2023.
//

import SpriteKit
import GameplayKit

final class SpriteComponent: GKComponent {
    let node: SKSpriteNode

    init(
        texture: SKTexture? = nil,
        color: UIColor? = nil,
        size: CGSize? = nil,
        initialPosition: CGPoint? = nil
    ) {
        self.node = SKSpriteNode(
            texture: texture,
            color: color ?? .white,
            size: size ?? .init(width: 0.5, height: 0.5)
        )
        super.init()
        if let position = initialPosition {
            node.position = position
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
