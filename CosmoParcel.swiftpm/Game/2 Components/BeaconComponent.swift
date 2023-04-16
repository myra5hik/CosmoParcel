//
//  BeaconComponent.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class BeaconComponent: GKComponent {
    private let radius: CGFloat

    init(radius: CGFloat) {
        self.radius = radius
        super.init()
    }

    func turnOn() {
        guard let parentNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            assertionFailure(); return
        }
        let beaconNode = Self.makeBeaconNode(radius: radius)
        beaconNode.zPosition = parentNode.zPosition + 1
        parentNode.addChild(beaconNode)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}

extension BeaconComponent {
    static func makeBeaconNode(radius: CGFloat) -> SKNode {
        // Node
        let node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = .systemRed
        node.strokeColor = .clear
        // Animation
        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let fadeCycle = SKAction.sequence([fadeOut, fadeIn])
        let infiniteAnimation = SKAction.repeatForever(fadeCycle)
        node.run(infiniteAnimation)
        return node
    }
}
