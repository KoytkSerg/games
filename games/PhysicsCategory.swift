//
//  PhysicsCategory.swift
//  games
//
//  Created by Sergii Kotyk on 29/4/2022.
//

import Foundation

struct PhysicsCategory {
    static let player: UInt32 = 1 << 0
    static let floor: UInt32 = 1 << 1
    static let wall: UInt32 = 1 << 2
    static let lightBall: UInt32 = 1 << 3
    static let edge: UInt32 = 1 << 31

}
