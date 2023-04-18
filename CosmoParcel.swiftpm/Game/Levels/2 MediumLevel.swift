//
//  2 MediumLevel.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import Foundation

extension Level {
    static func mediumLevel() -> Level {
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

    static func mediumLevelDescription() -> LevelDescription {
        LevelDescription(
            title: "Two Planets and Satellite",
            detail: "Abc",
            difficulty: .medium
        )
    }
}
