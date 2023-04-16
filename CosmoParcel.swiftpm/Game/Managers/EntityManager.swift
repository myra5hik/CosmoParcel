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
    private(set) var entities = Set<GKEntity>()
    weak private var scene: GameScene?

    init(scene: GameScene) {
        self.scene = scene
    }

    func add(entity: GKEntity) {
        // Holds the reference
        entities.insert(entity)
        // Adds to the scene
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            scene?.addChild(node)
        }
        // Adds to the systems
        for system in scene?.systems ?? [] {
            system.addComponent(foundIn: entity)
        }
    }

    func remove(entity: GKEntity) {
        // Releases the entity
        guard let removed = entities.remove(entity) else { return }
        // Removes from the scene
        if let node = removed.component(ofType: SpriteComponent.self)?.node {
            node.removeFromParent()
        }
        // Removes from the systems
        for system in scene?.systems ?? [] {
            system.removeComponent(foundIn: removed)
        }
    }
}
