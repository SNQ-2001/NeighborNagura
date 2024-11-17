//
//  BallState.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import Foundation

class BallState: Codable, Equatable {
    var position: BallPosition
    
    init(position: BallPosition) {
        self.position = position
    }
    
    static func ==(lhs: BallState, rhs: BallState) -> Bool {
        return lhs.position == rhs.position
    }
}

struct BallPosition: Codable, Equatable {
    var x: Double
    var y: Double
}

struct BallAcceleration: Codable, Equatable {
    let x: Double
    let y: Double
    let z: Double
}
