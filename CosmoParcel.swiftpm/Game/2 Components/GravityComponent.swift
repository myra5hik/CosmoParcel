//
//  GravityComponent.swift
//  
//
//  Created by Alexander Tokarev on 07.04.2023.
//

import Foundation
import SceneKit
import GameplayKit

final class GravityComponent: GKComponent {
    static let bigG = 6.6743 * pow(10.0, -11.0)
    let mass: Double
    var fieldStrength: Double {
        let scale = GameScaling.scalingVsSpriteKit
        // Field strength = G * M / r^2 => corrected by scale^(-2)
        return Self.bigG * mass * (scale * scale)
    }

    init(mass: Double, node: SKNode) {
        self.mass = mass
        super.init()
        setPhysicsBodyParameters(node)
        addRadialGravity(node)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    func setOrbiting(around other: GKEntity, clockwise: Bool = true) {
        guard
            let sprite = self.entity?.component(ofType: SpriteComponent.self),
            let otherGravity = other.component(ofType: GravityComponent.self),
            let otherSprite = other.component(ofType: SpriteComponent.self)
        else { assertionFailure(); return }

        // NOTE: 150 comes from the fact that SpriteKit uses 150 pts / m scaling
        // Calculating magnitude of the applied impulse
        /// Orbit radius
        let r = sprite.distance(to: otherSprite) / 150
        // v = sqrt(G * M / r) = sqrt(fieldStrength / r)
        /// Orbital velocity
        let v = sqrt(otherGravity.fieldStrength / r)
        let momentum = v * self.mass * 150
        // Calculating vector via the angle to apply the impulse towards
        // Angle is rotated by 90° agains gravitational force
        let angle = sprite.angle(to: otherSprite) + (clockwise ? .pi / 2 : -.pi / 2)
        let impulse = CGVector(dx: cos(angle) * momentum, dy: sin(angle) * momentum)
        sprite.node.physicsBody?.applyImpulse(impulse)
    }

    func thrustRequiredToEscape(rocketHeight: Double, rocketMass: Double) -> Double {
        guard let ownNode = self.entity?.component(ofType: SpriteComponent.self)?.node else {
            assertionFailure(); return 0.0
        }
        // NOTE: 150 comes from the fact that SpriteKit uses 150 pts / m scaling
        let planetRadius = (ownNode.size.width / 2) / 150
        let rocketCenterDistance = (rocketHeight / 2) / 150
        let totalDistance = planetRadius + rocketCenterDistance
        // F = G * M * m / r^2, where G * M = fieldStrength
        let requiredThrust = fieldStrength * rocketMass / (totalDistance * totalDistance) * 150
        return requiredThrust
    }
}

// MARK: - Private

private extension GravityComponent {
    func setPhysicsBodyParameters(_ node: SKNode) {
        node.physicsBody?.mass = mass
        node.physicsBody?.linearDamping = 0.0
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.angularDamping = 1.0
        node.physicsBody?.friction = 0.9
    }

    func addRadialGravity(_ node: SKNode) {
        let field = SKFieldNode.radialGravityField()
        field.falloff = 2
        field.strength = Float(fieldStrength)
        field.position = .zero
        node.addChild(field)
    }
}
