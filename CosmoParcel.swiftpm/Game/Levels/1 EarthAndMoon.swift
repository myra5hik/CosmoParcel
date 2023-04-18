//
//  1 EarthAndMoon.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import Foundation

extension Level {
    static func earthAndMoon() -> Level {
        // Scales
        let metersPerPoint = GameScaling.metersPerPoint
        let cosmicObjectsScaleVsReality = GameScaling.cosmicObjectsScaleVsReality
        // Earth
        let earthRadius = 6_378_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let earth = CosmicObject(
            mass: 5.972168 * pow(10, 24),
            position: .init(x: 500, y: 500),
            size: .init(width: earthRadius * 2, height: earthRadius * 2),
            texture: .planetWet
        )
        // Moon
        let moonRadius = 1_738_100 / metersPerPoint * cosmicObjectsScaleVsReality
        let moon = CosmicObject(
            mass: 7.342 * pow(10, 22),
            position: .init(x: 500, y: 500 + 384_399_000 / metersPerPoint),
            size: .init(width: moonRadius * 2, height: moonRadius * 2),
            texture: .moon1
        )
        // Level
        return Level(
            launchObject: earth,
            targetObject: moon,
            otherObjects: [],
            orbitingPairs: [
                (moon, orbitsAround: earth, clockwise: true)
            ]
        )
    }

    static func earthAndMoonDescription() -> LevelDescription {
        LevelDescription(
            title: "Earth and Moon",
            detail: "Abc",
            difficulty: .easy
        )
    }
}
