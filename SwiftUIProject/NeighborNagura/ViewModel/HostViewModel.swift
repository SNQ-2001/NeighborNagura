//
//  HostViewModel.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class HostViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let serviceType = "nearby-devices"
    
    @Published var peers: [PeerDevice] = []
    var selectedPeers: [PeerDevice] = []
    var joinedPeers: [PeerDevice] = []
    
    let gameState: GameState
    let messageReceiver = PassthroughSubject<P2PMessage, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(gameState: GameState) {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        self.gameState = gameState
        self.gameState.setProperties(_session: MCSession(peer: peer), _ballState: BallState(position: BallPosition(x: 0, y: 0)))
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
        gameState.session!.delegate = self
        
        messageReceiver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.receiveMessage(_message: $0)
            }
            .store(in: &subscriptions)
        
        browser.startBrowsingForPeers()
    }
    
    func finishBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    // ① 部屋を用意して，相手を招待する
    func invite(_selectedPeer: PeerDevice) {
        selectedPeers.append(_selectedPeer)
        guard gameState.session != nil else {
            print("Failed to invite peer: session is nil")
            return
        }
        browser.invitePeer(_selectedPeer.peerId, to: gameState.session!, withContext: nil, timeout: 60)
    }
    
    // ② 招待した相手が入っていたら，この関数を使って自分も部屋に入ったことにする
    func join() {
        if !isParticipantsJoined() {
            return
        }
        
        joinedPeers = selectedPeers
    }
    
    func isParticipantsJoined() -> Bool {
        guard let session = gameState.session else {
            print("Failed to check if participants are joined: session is nil")
            return false
        }
        if selectedPeers.count == 0 || !selectedPeers.allSatisfy({session.connectedPeers.contains($0.peerId)}) {
            return false
        }
        
        return true
    }
    
    private func receiveMessage(_message: P2PMessage) {
        switch _message.type {
        case .updateBallStateMessage:
            guard let message = UpdateBallStateMessage.fromJson(jsonString: _message.jsonData) else {
                print("Failed to decode BallState from JSON: \(_message.jsonData)")
                return
            }
            gameState.updateBallState(_ballState: message.ballState)
        }
    }
    
    func sendUpdateBallStateMessage(_ballState: BallState) {
        guard let jsonData = UpdateBallStateMessage(ballState: _ballState).toJson() else {
            return
        }
        guard let messageData = P2PMessage(type: .updateBallStateMessage, jsonData: jsonData).toSendMessage().data(using: .utf8) else {
            return
        }

        // 相手に送信
        // try? session.send(data, toPeers: [joinedPeer.last!.peerId], with: .reliable)
        let peerIds = joinedPeers.map { $0.peerId }
        try? gameState.session?.send(messageData, toPeers: peerIds, with: .reliable)
        
        // 自分にも送信
        messageReceiver.send(P2PMessage(type: .updateBallStateMessage, jsonData: jsonData))
    }
}

extension HostViewModel: MCNearbyServiceBrowserDelegate {
    // 接続可能なデバイスをappendする
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}



extension HostViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        //
    }
}

extension HostViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //
    }
    
    // sessionを通して送られてくるmessageをViewLogicのballStateReceiverに流す
    func session(_ session: MCSession, didReceive data: Data, fromPeer fromPeerID: MCPeerID) {
        // guard let last = joinedPeers.last, last.peerId == peerID, let message = String(data: data, encoding: .utf8) else {
        guard joinedPeers.map({$0.peerId}).contains([fromPeerID]), let message = String(data: data, encoding: .utf8) else {
            return
        }
        
        guard let _message = P2PMessage.fromReceivedMessage(message: message) else {
            return
        }
        
        messageReceiver.send(_message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
    
}
