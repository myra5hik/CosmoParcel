
import SwiftUI
import SpriteKit
import GameplayKit

@main
struct CosmoParcelApp: App {
    var body: some Scene {
        WindowGroup {
            GameplayView(level: .tutorial)
        }
    }
}
