//
//  GameplayView.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import SwiftUI
import SpriteKit

struct GameplayView: View {
    @ObservedObject private(set) var vm: ViewModel

    init(vm: ViewModel) {
        self.vm = vm
    }

    var body: some View {
        gamePlayView.padding(.horizontal)
    }

    private var gamePlayView: some View {
        GeometryReader { proxy in
            // Calculations
            let isLandscape = proxy.size.width > proxy.size.height
            // Views
            let spriteView = SpriteView(
                scene: vm.scene,
                options: .ignoresSiblingOrder
            )
            .aspectRatio(1.0, contentMode: .fit)
            .mask { RoundedRectangle(cornerRadius: 12) }
            .layoutPriority(1)
            .id(ObjectIdentifier(vm.scene))
            // Control panel is vertical (= thin) when GameplayView is in landscape mode
            let controlPanel = ControlPanelView(gameState: vm.gameState, isVertical: isLandscape)
                .padding()
            // Return
            if isLandscape {
                HStack { spriteView; controlPanel }
            } else {
                VStack { spriteView; controlPanel }
            }
        }
    }
}

// MARK: - ViewModel

extension GameplayView {
    final class ViewModel: ObservableObject {
        private(set) var scene: GameScene
        private(set) var gameState: GameState
        private(set) var level: Level?
        private let levelProvider: () -> Level
        private var entityManager: EntityManager

        init(levelProvider: @escaping () -> Level) {
            // Creates dependencies
            let scene = GameScene()
            self.scene = scene
            self.entityManager = EntityManager(scene: scene)
            self.levelProvider = levelProvider
            // Sets game state
            self.gameState = GameState(scene: scene, entityManager: entityManager)
        }

        func startOrRestartLevel() {
            scene = GameScene()
            entityManager = EntityManager(scene: scene)
            let level = levelProvider()
            self.level = level
            level.load(into: scene, entityManager: entityManager)
            gameState = GameState(scene: scene, entityManager: entityManager)
            gameState.startGame()
            objectWillChange.send()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                level.applyInitialPhysics()
            }
        }
    }
}

// MARK: - Previews

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = GameplayView.ViewModel(levelProvider: { .earthAndMoon() })
        GameplayView(vm: vm)
    }
}
