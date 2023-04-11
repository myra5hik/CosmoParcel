//
//  SKSceneView.swift
//  
//
//  Created by Alexander Tokarev on 06.04.2023.
//

import SwiftUI
import SpriteKit

struct SKSceneView: UIViewRepresentable {
    let scene: SKScene

    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.presentScene(scene)
        skView.contentMode = .scaleAspectFit
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        return skView
    }

    func updateUIView(_ view: SKView, context: Context) { }
}
