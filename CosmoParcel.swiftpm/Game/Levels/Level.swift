//
//  Level.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation

struct Level {
    // Objects
    let launchObject: CosmicObject
    let targetObject: CosmicObject
    let otherObjects: [CosmicObject]
    // Movement configuration
    let orbitingPairs: [(CosmicObject, orbitsAround: CosmicObject, clockwise: Bool)]

    // MARK: Load methods

    func load(into scene: GameScene, entityManager: EntityManager) {
        // Launch from cosmic object
        launchObject.addComponent(ContactComponent(
            ownMask: .launchFromObject, contactTestMask: [], collisionMask: [.targetObject, .otherObject]
        ))
        entityManager.add(entity: launchObject)
        // Target object
        let targetNode = targetObject.component(ofType: SpriteComponent.self)?.node
        let targetRadius = (targetNode?.size.height ?? 10.0) / 2.0
        targetObject.addComponent(BeaconComponent(radius: targetRadius * 0.4))
        targetObject.addComponent(ContactComponent(
            ownMask: .targetObject, contactTestMask: [], collisionMask: [.launchFromObject, .otherObject]
        ))
        entityManager.add(entity: targetObject)
        targetObject.component(ofType: BeaconComponent.self)?.turnOn()
        // Other objects
        for object in otherObjects {
            object.addComponent(ContactComponent(
                ownMask: .otherObject, contactTestMask: [], collisionMask: [.launchFromObject, .targetObject]
            ))
            entityManager.add(entity: object)
        }
        // Rocket - Basic setup
        let rocketMass = 1000.0
        let rocketHeight = 12.0
        let engineThrust = launchObject.component(ofType: GravityComponent.self)?
            .thrustRequiredToEscape(rocketHeight: rocketHeight, rocketMass: rocketMass) ?? 0.0
        guard let launchFromNode = launchObject.component(ofType: SpriteComponent.self)?.node else {
            assertionFailure(); return
        }
        let launchFromRadius = launchFromNode.size.height / 2
        let initialPosition = CGPoint(
            x: launchFromNode.position.x,
            y: launchFromNode.position.y + launchFromRadius + rocketHeight / 2
        )
        let rocket = Rocket(
            mass: rocketMass,
            position: initialPosition,
            height: rocketHeight,
            thrust: engineThrust * (1 + 0.1 * GameScaling.scalingVsSpriteKit),
            launchFromObject: launchObject
        )
        // Rocket - Engine shutdown setup, will turn off as soon as the rocket reaches escape velocity
        let engine = rocket.component(ofType: EngineComponent.self)
        let launchObjectGravity = launchObject.component(ofType: GravityComponent.self)
        engine?.shutDownCondition = { [weak rocket, weak launchObjectGravity] in
            guard let rocket = rocket, let launchObjectGravity = launchObjectGravity else { return false }
            return launchObjectGravity.hasReachedEscapeVelocity(rocket)
        }
        // Rocket - Add entity
        entityManager.add(entity: rocket)
    }

    func applyInitialPhysics() {
        // Movement configurations
        for pair in orbitingPairs {
            let anchor = pair.orbitsAround
            let satellite = pair.0
            let clockwise = pair.clockwise
            satellite.component(ofType: GravityComponent.self)?.setOrbiting(around: anchor, clockwise: clockwise)
        }
    }
}
