//
//  GameState.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import MultipeerConnectivity

enum GamePhase: Int, Codable {
    case prepare = 0
    case started = 1
    case gaming = 2
    case finished = 3
}


class GameState: ObservableObject, Equatable {
    @Published var session: MCSession? = nil
    @Published var ballState: BallState? = nil
    @Published var phase: GamePhase = GamePhase.prepare
    
    @Published var ballAcceleration: BallAcceleration = .init(x: 0, y: 0, z: 0)
    
    func setProperties(_session: MCSession, _ballState: BallState) {
        self.session = _session
        self.ballState = _ballState
    }
    
    func updateBallState(_ballState: BallState) {
        self.ballState = _ballState
    }
    
    func updateSession(_session: MCSession) {
        self.session = _session
    }
    
    func updatePhase(phase: GamePhase) {
        self.phase = phase
    }
    
    static func ==(lhs: GameState, rhs: GameState) -> Bool {
        return lhs.session == rhs.session && lhs.ballState == rhs.ballState
    }
}
