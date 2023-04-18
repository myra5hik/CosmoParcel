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
    var isOn = false {
        didSet { handleIsOnSet() }
    }
    var shutDownCondition: (() -> Bool)?
    // Public
    let thrust: CGFloat
    // Private
    static private var fireAtlas = SKTextureAtlas(named: "Fire")
    private var fireNode: SKSpriteNode?

    init(thrust: CGFloat) {
        self.thrust = thrust
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard isOn else { return }
        guard seconds < 1 else { return }
        guard shutDownCondition?() ?? false == false else { isOn = false; return }
        guard let node = self.entity?.component(ofType: SpriteComponent.self)?.node else { assertionFailure(); return }

        let angle = node.zRotation + .pi / 2 // Texture is vertical
        let force = CGVector(dx: cos(angle) * thrust, dy: sin(angle) * thrust)
        node.physicsBody?.applyForce(force)
    }

    private func handleIsOnSet() {
        if isOn {
            addExhaustFireNode()
        } else {
            removeExhaustFireNode()
        }
    }

    private func addExhaustFireNode() {
        guard fireNode == nil else { return }
        guard
            let rocket = self.entity as? Rocket,
            let rocketNode = rocket.component(ofType: SpriteComponent.self)?.node
        else { assertionFailure(); return }

        // Node
        let atlas = Self.fireAtlas
        let firstFrame = atlas.textureNamed("tile000")
        let ratio = firstFrame.size().height / firstFrame.size().width
        let w = rocketNode.size.width
        let h = w * ratio
        let node = SKSpriteNode(
            color: .clear,
            size: .init(width: w, height: h)
        )
        node.zPosition = rocketNode.zPosition - 0.01
        node.zRotation = .pi // texture is up
        node.position.y = -rocketNode.size.height * 0.8
        // Save reference
        fireNode = node
        // Animation
        let frames = atlas.textureNames.sorted().compactMap { atlas.textureNamed($0) }
        guard !frames.isEmpty else { assertionFailure(); return }
        let oneRun = SKAction.animate(with: frames, timePerFrame: 1 / 30)
        let infiniteAnimation = SKAction.repeatForever(oneRun)
        node.run(infiniteAnimation)
        // Add to rocket
        rocketNode.addChild(node)
        // Animate appearance
        node.alpha = 0.0
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        node.run(fadeIn)
    }

    private func removeExhaustFireNode() {
        guard let node = fireNode else { return }
        node.removeFromParent()
        fireNode = nil
    }
}
