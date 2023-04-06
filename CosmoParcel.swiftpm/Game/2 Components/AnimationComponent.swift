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
        fps: Double = 12
    ) {
        self.node = node
        self.frames = atlas?.textureNames.sorted(by: {
            if $0.count < $1.count { return true }
            if $0.count > $1.count { return false }
            return $0 < $1
        }).compactMap {
            atlas?.textureNamed($0)
        } ?? []
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
