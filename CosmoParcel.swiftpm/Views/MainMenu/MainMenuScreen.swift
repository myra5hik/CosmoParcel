//
//  MainMenuScreen.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import SwiftUI

struct MainMenuScreen: View {
    var body: some View {
        NavigationView {
            navigationList
            AboutTheGameScreen()
        }
    }

    private var navigationList: some View {
        List {
            Section("CosmoParcel Game") {
                aboutList
            }
            Section("Game Levels") {
                levelsList
            }
            Section("Credits") {
                creditsList
            }
        }
    }

    private var aboutList: some View {
        Group {
            NavigationLink("About the Game") {
                AboutTheGameScreen()
            }
        }
    }

    private var levelsList: some View {
        Group {
            NavigationLink("Earth and Moon") {
                LevelLoadView(
                    description: Level.earthAndMoonDescription(),
                    levelProvider: { Level.earthAndMoon() }
                )
            }
            NavigationLink("Medium") {
                LevelLoadView(
                    description: Level.triadLevelDescription(),
                    levelProvider: { Level.triadLevel() }
                )
            }
        }
    }

    private var creditsList: some View {
        Group {
            NavigationLink("List of materials") {
                CreditsScreen()
            }
        }
    }
}

// MARK: - Previews

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
