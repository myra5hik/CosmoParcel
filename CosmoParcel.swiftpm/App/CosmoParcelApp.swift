
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
        let planetRadius = 50
        let planet = CosmicObject(
            mass: 10_000_000_000,
            position: .init(x: 500, y: 500),
            size: .init(width: planetRadius, height: planetRadius)
        )
        entityManager.add(entity: planet)

        let satelliteRadius = 10
        let satellite = CosmicObject(
            mass: 1_000,
            position: .init(x: 500, y: 900),
            size: .init(width: satelliteRadius, height: satelliteRadius)
        )
        entityManager.add(entity: satellite)

        satellite.component(ofType: GravityComponent.self)?.setOrbiting(around: planet)
    }

    var body: some Scene {
        WindowGroup {
            SKSceneView(scene: scene).frame(width: 1000, height: 1000)
        }
    }
}
