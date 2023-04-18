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
        let fadeAndEnlarge = SKAction.group([
            SKAction.fadeOut(withDuration: 3.0),
            SKAction.scale(to: 3.0, duration: 3.0)
        ])
        let reset = SKAction.group([
            .scale(to: 1.0, duration: .leastNonzeroMagnitude),
            .fadeIn(withDuration: .leastNonzeroMagnitude)
        ])
        let cycle = SKAction.sequence([fadeAndEnlarge, reset])
        let infiniteAnimation = SKAction.repeatForever(cycle)
        node.run(infiniteAnimation)
        return node
    }
}
