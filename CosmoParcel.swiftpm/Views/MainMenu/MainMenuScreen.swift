//
//  MainMenuScreen.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import SwiftUI

struct MainMenuScreen: View {
    @State private var destination: Destination = Destination.aboutScreen

    var body: some View {
        navigationView
    }

    @ViewBuilder
    private var navigationView: some View {
        if #available(iOS 16, *) {
            NavigationSplitView {
                navigationList
            } detail: {
                screen(for: destination)
            }
        } else {
            NavigationView {
                navigationList
                screen(for: .aboutScreen)
            }
        }
    }

    private var navigationList: some View {
        List() {
            aboutList
            Section("Game Levels") { levelsList }
            Section("Credits") { creditsList }
        }
        .navigationTitle("CosmoParcel")
    }

    private var aboutList: some View {
        Group {
            cell(for: .aboutScreen)
        }
    }

    private var levelsList: some View {
        Group {
            cell(for: .level1)
            cell(for: .level2)
        }
    }

    private var creditsList: some View {
        Group {
            cell(for: .credits)
        }
    }
}

// MARK: - Component factories

private extension MainMenuScreen {
    @ViewBuilder
    private func screen(for selection: Destination) -> some View {
        switch selection {
        case .aboutScreen: AboutTheGameScreen()
        case .level1: LevelLoadView(description: Level.triadLevelDescription(), levelProvider: { Level.triadLevel() })
        case .level2: LevelLoadView(description: Level.earthAndMoonDescription(), levelProvider: { Level.earthAndMoon() })
        case .credits: CreditsScreen()
        }
    }

    @ViewBuilder
    func cell(for destination: Destination) -> some View {
        let label: () -> AnyView = {
            switch destination {
            case .aboutScreen: return AnyView(Text("About the Game"))
            case .level1: return AnyView(cell(for: Level.triadLevelDescription(), isRecommended: true))
            case .level2: return AnyView(cell(for: Level.earthAndMoonDescription()))
            case .credits: return AnyView(Text("List of materials"))
            }
        }

        NavigationLink(destination: screen(for: destination), label: label)
    }

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

// MARK: - Navigation destinations

private extension MainMenuScreen {
    enum Destination: String, Hashable {
        case aboutScreen
        case level1
        case level2
        case credits
    }
}

// MARK: - Previews

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
