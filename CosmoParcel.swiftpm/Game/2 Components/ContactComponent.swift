//
//  File.swift
//  
//
//  Created by Alexander Tokarev on 17.04.2023.
//

import Foundation
import SpriteKit
import GameplayKit

final class ContactComponent: GKComponent {
    let ownMask: UInt32
    let contactTestMask: UInt32
    let collisionMask: UInt32

    init(ownMask: UInt32, contactTestMask: [UInt32], collisionMask: [UInt32]) {
        self.ownMask = ownMask
        self.contactTestMask = contactTestMask.reduce(0b0, { $0 | $1 })
        self.collisionMask = collisionMask.reduce(0b0, { $0 | $1 })
        super.init()
    }

    convenience init(ownMask: Mask, contactTestMask: [Mask], collisionMask: [Mask]) {
        self.init(
            ownMask: ownMask.rawValue,
            contactTestMask: contactTestMask.map(\.rawValue),
            collisionMask: collisionMask.map(\.rawValue)
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    override func didAddToEntity() {
        super.didAddToEntity()
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node, node.physicsBody != nil else {
            assertionFailure(); return
        }

        node.physicsBody?.categoryBitMask = ownMask
        node.physicsBody?.contactTestBitMask = contactTestMask
        node.physicsBody?.collisionBitMask = collisionMask
    }
}

// MARK: Predefined masks

extension ContactComponent {
    enum Mask: UInt32 {
        case rocket =           0b0001
        case launchFromObject = 0b0010
        case targetObject =     0b0100
        case otherObject =      0b1000
    }
}
