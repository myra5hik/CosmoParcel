
import SwiftUI
import SpriteKit
import GameplayKit

let level = Level.triadLevel()

@main
struct CosmoParcelApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuScreen()
//            GameplayView(level: level)
                .preferredColorScheme(.dark)
        }
    }
}
