//
//  Level.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation

struct Level {
    // Scales
    private static let metersPerPoint = GameScaling.metersPerPoint
    private static let cosmicObjectsScaleVsReality = GameScaling.cosmicObjectsScaleVsReality
    // Objects
    let launchObject: CosmicObject
    let targetObject: CosmicObject
    let otherObjects: [CosmicObject]
    // Movement configuration
    let orbitingPairs: [(CosmicObject, orbitsAround: CosmicObject, clockwise: Bool)]

    // MARK: Load methods

    func load(into scene: GameScene, entityManager: EntityManager) {
        // Launch from cosmic object
        entityManager.add(entity: launchObject)
        // Target object
        let targetNode = targetObject.component(ofType: SpriteComponent.self)?.node
        let targetRadius = (targetNode?.size.height ?? 10.0) / 2.0
        targetObject.addComponent(BeaconComponent(radius: targetRadius * 0.4))
        entityManager.add(entity: targetObject)
        targetObject.component(ofType: BeaconComponent.self)?.turnOn()
        // Other objects
        for object in otherObjects {
            entityManager.add(entity: object)
        }
        // Movement configurations
        for pair in orbitingPairs {
            let anchor = pair.orbitsAround
            let satellite = pair.0
            let clockwise = pair.clockwise
            satellite.component(ofType: GravityComponent.self)?.setOrbiting(around: anchor, clockwise: clockwise)
        }
        // Rocket - Basic setup
        let rocketMass = 10.0
        let rocketHeight = 10.0
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
}

// MARK: - Tutorial level

extension Level {
    static var tutorial: Level {
        // Earth
        let earthRadius = 6_378_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let earth = CosmicObject(
            mass: 5.972168 * pow(10, 24),
            position: .init(x: 500, y: 500),
            size: .init(width: earthRadius * 2, height: earthRadius * 2),
            texture: .planet1
        )
        // Moon
        let moonRadius = 1_738_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let moon = CosmicObject(
            mass: 7.342 * pow(10, 22),
            position: .init(x: 500, y: 500 + 384_399_000 / metersPerPoint),
            size: .init(width: moonRadius * 2, height: moonRadius * 2),
            texture: .moon1
        )
        // Level
        return Level(
            launchObject: earth,
            targetObject: moon,
            otherObjects: [],
            orbitingPairs: [
                (moon, orbitsAround: earth, clockwise: true)
            ]
        )
    }
}
