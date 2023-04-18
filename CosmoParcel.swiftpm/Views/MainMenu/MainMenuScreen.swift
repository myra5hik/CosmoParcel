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
            detailView
        }
    }

    private var navigationList: some View {
        List {
            Section("Section") {
                aboutList
            }
            Section("Game Levels") {
                levelsList
            }
        }
    }

    private var detailView: some View {
        Text("Detail")
    }

    private var aboutList: some View {
        Group {
            Text("1")
            Text("2")
            Text("3")
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
                    description: Level.mediumLevelDescription(),
                    levelProvider: { Level.mediumLevel() }
                )
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
