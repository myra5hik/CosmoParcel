//
//  2 MediumLevel.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import Foundation

extension Level {
    static func triadLevel() -> Level {
        // Scales
        let metersPerPoint = GameScaling.metersPerPoint
        let cosmicObjectsScaleVsReality = GameScaling.cosmicObjectsScaleVsReality
        // Planet 1
        let homePlanetRadius = 8_000_000 / metersPerPoint * cosmicObjectsScaleVsReality
        let homePlanetMass = Double(4.0 * pow(10, 24))
        let homePlanet = CosmicObject(
            mass: homePlanetMass,
            position: .init(x: 0 + homePlanetRadius / 2, y: 0 + homePlanetRadius / 2),
            size: .init(width: homePlanetRadius * 2, height: homePlanetRadius * 2),
            texture: .planetWet
        )
        // Planet 2
        let planet2Radius = homePlanetRadius * 1.1
        let planet2 = CosmicObject(
            mass: homePlanetMass * 0.42,
            position: .init(x: 550, y: 50),
            size: .init(width: planet2Radius * 2, height: planet2Radius * 2),
            texture: .planetDry
        )
        // Satellite
        let satelliteRadius = homePlanetRadius * 0.8
        let satellite = CosmicObject(
            mass: homePlanetMass * 0.73,
            position: .init(x: 700, y: 770),
            size: .init(width: satelliteRadius, height: satelliteRadius),
            texture: .moon1
        )
        // Level
        return Level(
            launchObject: homePlanet,
            targetObject: satellite,
            otherObjects: [planet2],
            orbitingPairs: [
                (planet2, orbitsAround: homePlanet, clockwise: false),
                (satellite, orbitsAround: homePlanet, clockwise: true)
            ]
        )
    }

    static func triadLevelDescription() -> LevelDescription {
        let detailText =
        """
        Welcome to the Tiard level!

        Your goal in this level is to deliver cargo to the satellite that orbits the outermost of three cosmic bodies.

        This level is designed to challenge players while helping them build their visual intuition about how gravity works. The effects of gravity from these three bodies will have a significant impact on the trajectory of the spacecraft.

        Unlike the "Earth and Moon" level, "Triad" does not replicate any particular real cosmic system. Instead, it was created to provide a challenging gameplay experience for players.

        T minus thirty and counting down.
        """

        return LevelDescription(
            title: "Triad",
            detail: detailText,
            difficulty: .medium
        )
    }
}
