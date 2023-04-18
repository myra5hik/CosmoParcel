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
            mass: 7.342 * pow(10, 22) * 10,
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
        let detailText =
        """
        Welcome to the Earth and Moon level!

        Your goal in this level is to deliver cargo to a human colony located on the Moon.

        It is an easy level designed to help players build their visual intuition about how gravity works. The effects of gravity will have a significant impact on spacecraft's trajectory.

        This level replicates the real scales of the Earth and Moon, with a few exceptions:
         • The cosmic bodies are 5x larger for better visibility on the map.
         • The Moon's mass has been increased 10x times to make gameplay easier.

        T minus thirty!
        """

        return LevelDescription(
            title: "Earth and Moon  🌍 🌘",
            detail: detailText,
            difficulty: .easy
        )
    }
}
