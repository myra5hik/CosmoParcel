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
    let isVertical: Bool

    var body: some View {
        let group = Group {
            if !isVertical { Spacer() }
            timeWarpIndicator
            Spacer()
            appropriateControlPanel
            Spacer()
        }

        if isVertical {
            VStack { group }
        } else {
            HStack { group }
        }
    }

    // MARK: Common

    private var timeWarpIndicator: some View {
        let box = withProminentBackground {
            let multiplier = gameState.timeWarp.formatted(.number.rounded().precision(.fractionLength(0)))
            return HStack {
                Image(systemName: "forward.fill")
                Text("Time speed: \(multiplier)x")
            }
        }

        if isVertical {
            return AnyView(box.frame(height: 50))
        } else {
            return AnyView(box.aspectRatio(1.0, contentMode: .fit))
        }
    }

    @ViewBuilder
    private var appropriateControlPanel: some View {
        switch gameState.stage {
        case .notStarted: EmptyView()
        case .intro: introHint
        case .positioning: positioningHint
        case .cruising: cruisingHint
        case .targetReached: targetReached
        }
    }

    // MARK: Intro

    private var introHint: some View {
        let text = [
            "Observe the conditions of the mission.",
            "The colony is sending a signal with a beacon.",
            "Your mission is to deliver the cargo to the colony."
        ].joined(separator: " ")

        return iconAndText(
            icon: "light.beacon.max.fill",
            text: text
        )
    }

    // MARK: Traversing

    private var cruisingHint: some View {
        return iconAndText(
            icon: "arrow.up.right",
            text: "The vehicle is cruising as per the set trajectory."
        )
    }

    private var positioningHint: some View {
        iconAndText(
            icon: "hand.draw.fill",
            text: "Set the liftoff trajectory on the map",
            accessory: { launchButton }
        )
    }

    private var launchButton: some View {
        Button("Launch the rocket") {
            gameState.launchRocket()
        }
        .buttonStyle(.borderedProminent)
        .font(.system(size: 16, weight: .medium))
    }

    // MARK: Target reached

    private var targetReached: some View {
        iconAndText(
            icon: "checkmark.square.fill",
            text: "Mission accomplished! You have delivered the parcel to the colony."
        )
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

    private func iconAndText<A: View>(
        icon: String,
        text: String,
        accessory: (() -> A) = { EmptyView() }
    ) -> some View {
        withProminentBackground {
            VStack(spacing: 30) {
                Image(systemName: icon).font(.system(size: 64))
                Text(text).multilineTextAlignment(.center)
                accessory()
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

// MARK: - Previews

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        let scene = GameScene()
        let entityManager = EntityManager(scene: scene)
        let gameState = GameState(scene: scene, entityManager: entityManager)

        return ControlPanelView(gameState: gameState, isVertical: true).frame(width: 300)
    }
}
