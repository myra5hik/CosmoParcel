//
//  CGVector+AdditiveArithmetic.swift
//  
//
//  Created by Alexander Tokarev on 07.04.2023.
//

import Foundation
import CoreGraphics

extension CGVector: AdditiveArithmetic {
    public static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }

    public static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    public static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        return lhs + (-rhs)
    }

    public static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs - rhs
    }
}
