//
//  TouchesInputNode.swift
//  
//
//  Created by Alexander Tokarev on 16.04.2023.
//

import Foundation
import SpriteKit

protocol ITouchesInputDelegate: AnyObject {
    func touch(at point: CGPoint)
    func touchEnded(at point: CGPoint)
}

final class TouchesInputNode: SKSpriteNode {
    override var canBecomeFirstResponder: Bool { true }
    override var isUserInteractionEnabled: Bool {
        get { true }
        set { } // Ignored
    }
    weak var delegate: ITouchesInputDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let scene = self.scene else { return }
        guard touches.count == 1, let onlyTouch = touches.first else { return }
        delegate?.touch(at: onlyTouch.location(in: scene))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let scene = self.scene else { return }
        guard touches.count == 1, let onlyTouch = touches.first else { return }
        delegate?.touch(at: onlyTouch.location(in: scene))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let scene = self.scene else { return }
        guard touches.count == 1, let onlyTouch = touches.first else { return }
        delegate?.touchEnded(at: onlyTouch.location(in: scene))
    }
}
