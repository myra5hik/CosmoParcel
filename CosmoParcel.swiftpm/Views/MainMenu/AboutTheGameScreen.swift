//
//  AboutTheGameScreen.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import SwiftUI

struct AboutTheGameScreen: View {
    let onTapOfPlay: () -> Void

    var body: some View {
        Form {
            textWall
            Section("Play the game") {
                playButton
            }
        }
        .navigationTitle("About the Game")
    }

    private var playButton: some View {
        Button("Go to a Game Level") {
            onTapOfPlay()
        }
    }

    private var textWall: some View {
        Group {
            Section {
                let string =
                """
                Welcome to the CosmoParcel game! 🚀
                This game helps players build their visual intuition about how gravity works.
                """
                Text(string)
            }
            Section("The Mission") {
                let string =
                """
                Player's mission is to deliver cargo to human colonies on different planets.
                """
                Text(string)
            }
            Section("The Simulation") {
                let string =
                """
                The game simulates real-world gravitational interactions of celestial bodies, as described \
                by Newton's laws, including when they are set to orbit another object.

                Same for the rocket, which accelerates and cruises in zero-gravity in a realistic manner.

                Finally, the time is manipulated to aid gameplay, and the speed is indicated to the user.
                """
                Text(string)
            }
            Section("The Gravity") {
                let string =
                """
                Players can only set the liftoff trajectory of the spaceship. \
                Cosmic bodies' gravitational pulls will influence the spacecraft's trajectory after initial \
                liftoff, requiring players to plan their initial trajectory carefully.
                Doing so will help understand the gravitational laws in a fun and engaging way.
                """
                Text(string)
            }
            Section("How to Play") {
                let string =
                """
                 • Choose one of the levels in the sidebar.
                 • Assess the level: the goal is to deliver the vehicle onto the body with a beacon on it.
                 • When prompted, set the rocket's linear liftoff trajectory.
                 • Press the "Launch" button for liftoff.
                 • The game is best enjoyed in landscape mode.
                """
                Text(string)
            }
        }
    }
}

// MARK: - Previews

struct AboutTheGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutTheGameScreen(onTapOfPlay: { /*Nothing*/ })
    }
}
