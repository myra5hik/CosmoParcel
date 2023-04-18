
import SwiftUI
import SpriteKit
import GameplayKit

let level = Level.earthAndMoon()

@main
struct CosmoParcelApp: App {
    var body: some Scene {
        WindowGroup {
            GameplayView(level: level)
                .preferredColorScheme(.dark)
        }
    }
}
