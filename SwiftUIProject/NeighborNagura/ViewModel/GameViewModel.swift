//
//  GameViewModel.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import MultipeerConnectivity
import SwiftUI

final class GameViewModel: ObservableObject {
    func sendGameBallAccelerationMessage(session: MCSession, ballAcceleration: BallAcceleration) {
        let encode = JSONEncoder()
        guard
            let encodedBallAcceleration = try? encode.encode(ballAcceleration),
            let jsonString = String(data: encodedBallAcceleration, encoding: .utf8)
        else {
            return
        }
        guard let messageData = P2PMessage(
            type: .gameBallAccelerationMessage,
            jsonData: jsonString
        ).toSendMessage().data(using: .utf8) else {
            return
        }
        // 相手に送信
        try? session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
    }
    
    func gameFinish(gameState: GameState) {
        gameState.updatePhase(phase: .finished)
        sendGameFinishMessage(session: gameState.session!)
    }
    
    private func sendGameFinishMessage(session: MCSession) {
        guard let messageData = P2PMessage(type: .gameFinishMessage, jsonData: "").toSendMessage().data(using: .utf8) else {
            return
        }
        // 相手に送信
        try? session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
    }
}
