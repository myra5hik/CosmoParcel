//
//  EngineComponent.swift
//  
//
//  Created by Alexander Tokarev on 12.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class EngineComponent: GKComponent {
    // Public settable
    var isOn = false
    // Public
    let thrust: CGFloat

    init(thrust: CGFloat) {
        self.thrust = thrust
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard seconds < 1 else { return }
        guard isOn else { return }
        
        guard let node = self.entity?.component(ofType: SpriteComponent.self)?.node else { assertionFailure(); return }
        let angle = node.zRotation + .pi / 2 // Texture is vertical
        let force = CGVector(dx: cos(angle) * thrust, dy: sin(angle) * thrust)
        node.physicsBody?.applyForce(force)
    }
}
