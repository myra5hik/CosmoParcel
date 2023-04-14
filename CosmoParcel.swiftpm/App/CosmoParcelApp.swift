
import SwiftUI
import SpriteKit

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
        // Adding entities
        let planetRadius = 6_378.1 / metersPerPoint * 5
        let planet = CosmicObject(
            mass: 1_000_000_000,
            position: .init(x: 500, y: 500),
            size: .init(width: planetRadius * 2, height: planetRadius * 2)
        )
        entityManager.add(entity: planet)

        let satelliteRadius = 1_738.1 / metersPerPoint * 5
        let satellite = CosmicObject(
            mass: 1_000,
            position: .init(x: 500, y: 500 + 384_399 / metersPerPoint),
            size: .init(width: satelliteRadius * 2, height: satelliteRadius * 2),
            texture: .moon1
        )
        entityManager.add(entity: satellite)
        satellite.component(ofType: GravityComponent.self)?.setOrbiting(around: planet)

        let rocketMass = 10.0
        let thrust = planet.component(ofType: GravityComponent.self)?.thrustRequiredToEscape(forRocketWithMass: rocketMass) ?? 0.0
        let rocketHeight = 10.0
        let rocket = Rocket(
            mass: rocketMass,
            position: .init(x: 500, y: 500 + planetRadius + rocketHeight / 2),
            height: rocketHeight,
            thrust: thrust * 1.1
        )
        rocket.component(ofType: EngineComponent.self)?.isOn = true
        entityManager.add(entity: rocket)
    }

    var body: some Scene {
        WindowGroup {
            SKSceneView(scene: scene).frame(width: 1000, height: 1000)
        }
    }
}
