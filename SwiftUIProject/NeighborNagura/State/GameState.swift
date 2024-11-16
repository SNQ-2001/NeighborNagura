//
//  GameState.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import MultipeerConnectivity

class GameState: ObservableObject, Equatable {
    @Published var session: MCSession? = nil
    @Published var ballState: BallState? = nil
    
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
    
    static func ==(lhs: GameState, rhs: GameState) -> Bool {
        return lhs.session == rhs.session && lhs.ballState == rhs.ballState
    }
}
