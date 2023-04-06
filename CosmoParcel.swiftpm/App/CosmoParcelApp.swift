
import SwiftUI
import SpriteKit

@main
struct CosmoParcelApp: App {
    private let scene: SKScene
    private let entityManager: EntityManager

    init() {
        let scene = SKScene()
        self.scene = scene
        self.entityManager = EntityManager(scene: scene)

        let planet = Planet()
        entityManager.add(entity: planet)
    }

    var body: some Scene {
        WindowGroup {
            SKSceneView(scene: scene)
                .frame(width: 500, height: 500)
        }
    }
}
