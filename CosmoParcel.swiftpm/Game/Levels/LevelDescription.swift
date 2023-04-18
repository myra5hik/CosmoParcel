//
//  LevelDescription.swift
//  
//
//  Created by Alexander Tokarev on 18.04.2023.
//

import Foundation

struct LevelDescription {
    let title: String
    let detail: String
    let difficulty: Difficulty
}

// MARK: - Difficulty

extension LevelDescription {
    enum Difficulty: String, CustomStringConvertible {
        case easy, medium, hard

        var description: String {
            self.rawValue.capitalized
        }
    }
}
