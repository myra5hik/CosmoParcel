//
//  File.swift
//  
//
//  Created by Alexander Tokarev on 15.04.2023.
//

import Foundation
import SpriteKit

extension SKNode {
    func distance(to other: SKNode) -> CGFloat {
        let dx = dx(to: other)
        let dy = dy(to: other)
        return sqrt(dx * dx + dy * dy)
    }

    func dx(to other: SKNode) -> CGFloat {
        return self.position.x - other.position.x
    }

    func dy(to other: SKNode) -> CGFloat {
        return self.position.y - other.position.y
    }

    func angle(to other: SKNode) -> Double {
        return atan2(other.dy(to: self), other.dx(to: self))
    }
}
