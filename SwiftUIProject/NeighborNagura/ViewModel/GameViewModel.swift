//
//  GameViewModel.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import MultipeerConnectivity
import SwiftUI

class GameViewModel: ObservableObject {
    func updateBallState(gameState: GameState, newBallState: BallState) {
        guard gameState.ballState != nil && gameState.session != nil else {
            print("Failed to update ball state: session or ballState is nil")
            return
        }
        gameState.updateBallState(_ballState: newBallState)
        sendUpdateBallStateMessage(session: gameState.session!, _ballState: newBallState)
    }
    
    private func sendUpdateBallStateMessage(session: MCSession, _ballState: BallState) {
        guard let jsonData = UpdateBallStateMessage(ballState: _ballState).toJson() else {
            return
        }
        guard let messageData = P2PMessage(type: .updateBallStateMessage, jsonData: jsonData).toSendMessage().data(using: .utf8) else {
            return
        }

        // 相手に送信
        try? session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
    }
}
