//
//  File.swift
//  
//
//  Created by Alexander Tokarev on 06.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class EntityManager {
    private var entities = Set<GKEntity>()
    weak private var scene: SKScene?

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(entity: GKEntity) {
        // Holds the reference
        entities.insert(entity)
        // Adds to the scene
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            scene?.addChild(node)
        }
    }

    func remove(entity: GKEntity) {
        // Releases the entity
        guard let removed = entities.remove(entity) else { return }
        // Removes from the scene
        if let node = removed.component(ofType: SpriteComponent.self)?.node {
            node.removeFromParent()
        }
    }
}
