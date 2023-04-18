//
//  CreditsScreen.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import SwiftUI

struct CreditsScreen: View {
    var body: some View {
        Form {
            Section { introText }
            ForEach(Self.models, id: \.title) {
                section(for: $0)
            }
        }
    }

    private var introText: some View {
        let string =
        """
        This page is to share the appreciation and gratitude to the people who were kind \
        to share their work under free and/or attribution-only licences.
        """

        return Text(string)
    }

    private func section(for config: CellConfig) -> some View {
        return Section {
            Text(config.title)
            if let details = config.details {
                Text(details)
            }
            if let license = config.license {
                Text("License: \(license)")
            }
            if let url = config.url {
                Link("Web page", destination: url)
            }
        }
    }
}

// MARK: - Cell Config

private extension CreditsScreen {
    struct CellConfig {
        let title: String
        let details: String?
        let license: String?
        let url: URL?
    }
}

// MARK: - Models

private extension CreditsScreen {
    static var models: [CellConfig] {
        [
            .init(
                title: "PixelPlanets",
                details: "A collection of shaders to generate pixel planets.",
                license: "MIT",
                url: URL(string: "https://github.com/Deep-Fold/PixelPlanets")
            ),
            .init(
                title: "FlatIcon Rocket ship image",
                details: nil,
                license: "Free",
                url: URL(string: "https://www.freepik.com/free-icon/rocket-ship_14016893.htm#page=6&query=rocket%20pixel%20art&position=8&from_view=search&track=ais")
            ),
            .init(
                title: "Ezfig Sprite sheet cutter",
                details: nil,
                license: "Free",
                url: URL(string: "https://ezgif.com/sprite-cutter")
            )
        ]
    }
}

// MARK: - Previews

struct CreditsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreditsScreen()
    }
}
