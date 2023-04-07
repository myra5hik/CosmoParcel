//
//  AnimationComponent.swift
//  
//
//  Created by Alexander Tokarev on 07.04.2023.
//

import GameplayKit

final class AnimationComponent: GKComponent {
    weak private var node: SKSpriteNode?
    private let frames: [SKTexture]
    private let fps: Double

    init(
        node: SKSpriteNode,
        atlas: SKTextureAtlas?,
        fps: Double = 24
    ) {
        self.node = node
        // Frames derived from atlas
        self.frames = atlas?.textureNames.sorted(by: {
            // If lengths differ (e.g., 'sprite-1' and 'sprite-11'), sorts by comparing lengths
            if $0.count < $1.count { return true }
            if $0.count > $1.count { return false }
            // If lengths do not differ (e.g. 'sprite-1' and 'sprite-2'), sorts by comparing names
            return $0 < $1
        }).compactMap {
            // Returns texture by its name in the bundle
            atlas?.textureNamed($0)
        } ?? []
        // Fps
        self.fps = fps
        super.init()
        animate()
    }

    func animate() {
        let oneRun = SKAction.animate(with: frames, timePerFrame: 1 / fps)
        let infiniteAnimation = SKAction.repeatForever(oneRun)
        node?.run(infiniteAnimation)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
}
