//
//  GameScaling.swift
//  
//
//  Created by Alexander Tokarev on 14.04.2023.
//

import Foundation

///
/// GameScaling factors are used across the game physics logic to overcome the fact that SpriteKit native scaling of 150 pts / 1m cannot be set to a different value.
/// Additionally, they set irrealistic scaling parameters so that the cosmic objects are more visible in the game scene.
///
enum GameScaling {
    /// Scaling in meters per 1 SpriteKit point
    static let metersPerPoint = 1_000_000.0
    /// Scaling ratio against SpriteKit's native scaling
    static let scalingVsSpriteKit = 1.0 / (150.0 * metersPerPoint)
    /// Additional irrealistic scaling of cosmic objects to aid gameplay
    static let cosmicObjectsScaleVsReality = 5.0
}
