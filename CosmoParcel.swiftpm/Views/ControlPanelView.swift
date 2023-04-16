//
//  ControlPanelView.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import SwiftUI

struct ControlPanelView: View {
    // Dependencies
    @ObservedObject var gameState: GameState

    var body: some View {
        Button("Launch Rocket") {
            gameState.launchRocket()
        }
    }
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        let scene = GameScene()
        let entityManager = EntityManager(scene: scene)
        let gameState = GameState(scene: scene, entityManager: entityManager)

        return ControlPanelView(gameState: gameState)
    }
}
