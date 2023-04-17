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
        VStack {
            timeWarpIndicator
            appropriateControlPanel
            Spacer()
        }
    }

    // MARK: Common

    private var timeWarpIndicator: some View {
        withProminentBackground {
            let multiplier = gameState.timeWarp.formatted(.number.rounded().precision(.fractionLength(0)))
            return Text("Time speed: \(multiplier)x")
        }
        .frame(height: 50)
    }

    @ViewBuilder
    private var appropriateControlPanel: some View {
        switch gameState.stage {
        case .notStarted, .intro, .traversing: EmptyView()
        case .positioning: positioningControlPanel
        case .targetReached: EmptyView()
        }
    }

    // MARK: Positioning

    private var positioningControlPanel: some View {
        VStack(spacing: 30) {
            positioningHint
            launchButton
        }
    }

    private var positioningHint: some View {
        withProminentBackground {
            VStack(spacing: 30) {
                Image(systemName: "hand.draw.fill").font(.system(size: 100))
                    .offset(x: -10)
                Text("Set the initial rocket's trajectory by dragging a finger over the screen")
                    .multilineTextAlignment(.center)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }

    private var launchButton: some View {
        Button("Launch the rocket") {
            gameState.launchRocket()
        }
        .buttonStyle(.borderedProminent)
        .font(.system(size: 16, weight: .medium))
    }

    // MARK: Convenience methods

    private func withProminentBackground<V: View>(_ contents: () -> V) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(.label.withAlphaComponent(0.1)))
            contents()
                .padding(20)
        }
    }
}

// MARK: - Previews

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        let scene = GameScene()
        let entityManager = EntityManager(scene: scene)
        let gameState = GameState(scene: scene, entityManager: entityManager)

        return ControlPanelView(gameState: gameState).frame(width: 300)
    }
}
