
import SwiftUI
import SpriteKit
import GameplayKit

@main
struct CosmoParcelApp: App {
    private let scene: SKScene
    private let entityManager: EntityManager

    init() {
        // Scene
        let scene = GameScene()
        self.scene = scene
        // Managers
        self.entityManager = EntityManager(scene: scene)
        // Scaling
        let metersPerPoint = GameScaling.metersPerPoint
        let cosmicObjectsScaleVsReality = GameScaling.cosmicObjectsScaleVsReality
        // Adding entities
        let planetRadius = 6_378_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let planet = CosmicObject(
            mass: 5.972168 * pow(10, 24),
            position: .init(x: 500, y: 500),
            size: .init(width: planetRadius * 2, height: planetRadius * 2)
        )
        entityManager.add(entity: planet)

        let satelliteRadius = 1_738_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let satellite = CosmicObject(
            mass: 7.342 * pow(10, 22),
            position: .init(x: 500, y: 500 + 384_399_000 / metersPerPoint),
            size: .init(width: satelliteRadius * 2, height: satelliteRadius * 2),
            texture: .moon1
        )
        entityManager.add(entity: satellite)
        satellite.component(ofType: GravityComponent.self)?.setOrbiting(around: planet)

        let rocketMass = 10.0
        let rocketHeight = 10.0
        let thrust = planet.component(ofType: GravityComponent.self)?
            .thrustRequiredToEscape(rocketHeight: rocketHeight, rocketMass: rocketMass) ?? 0.0
        let rocket = Rocket(
            mass: rocketMass,
            position: .init(x: 500, y: 500 + planetRadius + rocketHeight / 2),
            height: rocketHeight,
            thrust: thrust * (1 + 0.1 * GameScaling.scalingVsSpriteKit)
        )

        let planetGravity = planet.component(ofType: GravityComponent.self)
        let engine = rocket.component(ofType: EngineComponent.self)
        engine?.isOn = true
        engine?.shutDownCondition = { [weak rocket, weak planetGravity] in
            guard let rocket = rocket, let planetGravity = planetGravity else { return false }
            return planetGravity.hasReachedEscapeVelocity(rocket)
        }
        entityManager.add(entity: rocket)
    }

    var body: some Scene {
        WindowGroup {
            SKSceneView(scene: scene).frame(width: 1000, height: 1000)
        }
    }
}
