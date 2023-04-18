//
//  LevelLoadView.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import SwiftUI

struct LevelLoadView: View {
    @State private var isShowingFullscreenCover = false
    private let description: LevelDescription
    private let levelProvider: () -> Level

    init(description: LevelDescription, levelProvider: @escaping () -> Level) {
        self.description = description
        self.levelProvider = levelProvider
    }

    var body: some View {
        levelDescription
            .navigationTitle(description.title)
            .fullScreenCover(
                isPresented: $isShowingFullscreenCover,
                onDismiss: nil,
                content: { fullscreenCover }
            )
    }

    private var levelDescription: some View {
        Form {
            // Detailed text
            Section {
                Text(description.detail)
            }
            // Difficulty
            Section {
                Text("Difficulty: \(description.difficulty.description)")
            }
            // Start button
            Section {
                HStack {
                    Button("Open this level") {
                        isShowingFullscreenCover = true
                    }
                }
            }
        }
    }

    private var fullscreenCover: some View {
        NavigationView {
            GameplayView(level: levelProvider())
                .navigationTitle(description.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem { modalCloseButton }
                }
        }
    }

    private var modalCloseButton: some View {
        Button("Close") {
            isShowingFullscreenCover = false
        }
    }
}

// MARK: - Preview

struct LevelLoadView_Previews: PreviewProvider {
    static var previews: some View {
        LevelLoadView(
            description: Level.mediumLevelDescription(),
            levelProvider: { Level.mediumLevel() }
        )
    }
}
