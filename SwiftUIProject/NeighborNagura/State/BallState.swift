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

class BallPosition: Decodable, Encodable {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func ==(lhs: BallPosition, rhs: BallPosition) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
