//
//  LaunchPositioningComponent.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class LaunchPositioningComponent: GKComponent {
    private var ownNode: SKSpriteNode? { entity?.component(ofType: SpriteComponent.self)?.node }
    private let launchFromObject: CosmicObject
    private var launchFromNode: SKSpriteNode? { launchFromObject.component(ofType: SpriteComponent.self)?.node }

    init(from object: CosmicObject) {
        self.launchFromObject = object
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}

// MARK: - ITouchesInputDelegate Conformance

extension LaunchPositioningComponent: ITouchesInputDelegate {
    func touch(at point: CGPoint) {
        handleTouch(point: point)
    }

    func touchEnded(at point: CGPoint) {
        handleTouch(point: point)
    }

    private func handleTouch(point: CGPoint) {
        guard let ownNode = ownNode, let launchFromNode = launchFromNode else { return }
        let cosmicObjectRadius = launchFromNode.size.height / 2
        let dx = point.x - launchFromNode.position.x
        let dy = point.y - launchFromNode.position.y
        let angle = atan2(dy, dx)
        let touchDistance = hypot(dy, dx)
        // Only reacts to touches outside the object, when touched in "the space"
        guard touchDistance > cosmicObjectRadius else { return }
        let positioningDistance = cosmicObjectRadius + ownNode.size.height / 2
        ownNode.position.x = positioningDistance * cos(angle) + launchFromNode.position.x
        ownNode.position.y = positioningDistance * sin(angle) + launchFromNode.position.y
        ownNode.zRotation = angle - .pi / 2 // Assumes texture is vertical
    }
}
