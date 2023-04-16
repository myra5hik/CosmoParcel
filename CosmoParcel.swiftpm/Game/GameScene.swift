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
    // State
    private var lastUpdate = 0.0
    // Systems
    private(set) lazy var systems: [GKComponentSystem] = {
        let engineSystem = GKComponentSystem(componentClass: EngineComponent.self)
        return [engineSystem]
    }()
    // Touches
    override var isUserInteractionEnabled: Bool {
        get { true }
        set { } // Ignored
    }
    weak var touchesDelegate: ITouchesInputDelegate? {
        didSet { touchesInputNode.delegate = touchesDelegate }
    }
    private var touchesInputNode: TouchesInputNode!

    init(touchesDelegate: ITouchesInputDelegate? = nil) {
        super.init(size: .init(width: 1000, height: 1000))
        addTouchesInputNode()
        setupPhysics()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }

    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - lastUpdate
        lastUpdate = currentTime
        for system in systems {
            system.update(deltaTime: delta)
        }
    }

    // MARK: Physics setup

    private func setupPhysics() {
        // Gravity will be driven by individual gravity fields of the cosmic objects
        physicsWorld.gravity = .zero
    }

    // MARK: Touches setup

    private func addTouchesInputNode() {
        let node = TouchesInputNode(color: .clear, size: self.size)
        node.position = .init(x: self.size.width / 2, y: self.size.height / 2)
        node.zPosition = 100
        self.touchesInputNode = node
        self.addChild(node)
        touchesInputNode.delegate = touchesDelegate
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        touchesInputNode?.removeFromParent()
        touchesInputNode = nil
        addTouchesInputNode()
    }
}
