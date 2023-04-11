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
    override init() {
        super.init(size: .init(width: 1000, height: 1000))
        physicsWorld.gravity = .zero
        physicsWorld.speed = 1
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
}
