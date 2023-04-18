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
            NavigationLink(
                destination: {
                    LevelLoadView(
                        description: Level.triadLevelDescription(),
                        levelProvider: { Level.triadLevel() }
                    )
                },
                label: { cell(for: Level.triadLevelDescription(), isRecommended: true) }
            )
            NavigationLink(
                destination: {
                    LevelLoadView(
                        description: Level.earthAndMoonDescription(),
                        levelProvider: { Level.earthAndMoon() }
                    )
                },
                label: { cell(for: Level.earthAndMoonDescription()) }
            )
//            NavigationLink("Earth and Moon") {
//                LevelLoadView(
//                    description: Level.earthAndMoonDescription(),
//                    levelProvider: { Level.earthAndMoon() }
//                )
//            }
//            NavigationLink("Medium") {
//                LevelLoadView(
//                    description: Level.triadLevelDescription(),
//                    levelProvider: { Level.triadLevel() }
//                )
//            }
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

private extension MainMenuScreen {
    func cell(for level: LevelDescription, isRecommended: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(level.title)
                if isRecommended {
                    Text("Recommended").font(.footnote)
                }
            }
            Spacer()
            difficultyLabel(for: level.difficulty)
        }
    }

    private func difficultyLabel(for difficulty: LevelDescription.Difficulty) -> some View {
        let color: Color = {
            switch difficulty {
            case .easy: return Color(.systemGreen)
            case .medium: return Color(.systemOrange)
            case .hard: return Color(.systemRed)
            }
        }()

        return Text(difficulty.description)
            .font(.caption)
            .foregroundColor(color)
    }
}

// MARK: - Previews

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
