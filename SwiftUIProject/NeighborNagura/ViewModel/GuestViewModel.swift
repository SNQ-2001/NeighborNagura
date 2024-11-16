//
//  GuestViewModel.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class GuestViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let serviceType = "nearby-devices"
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    @Published var permissionRequest: PermissionRequest?
    
    @Published var joinedPeers: [PeerDevice] = []
    
    var gameState: GameState
    let messageReceiver = PassthroughSubject<P2PMessage, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    @Published var userRole: Unity.UserRole?
    
    init(gameState: GameState) {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        self.gameState = gameState
        self.gameState.setProperties(_session: MCSession(peer: peer), _ballState: BallState(position: BallPosition(x: 0, y: 0)))
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        
        super.init()
        
        advertiser.delegate = self
        gameState.session!.delegate = self
        
        messageReceiver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.receiveMessage(_message: $0)
            }
            .store(in: &subscriptions)
        
        advertiser.startAdvertisingPeer()
    }
    
    func join(peer: PeerDevice) {
        joinedPeers.append(peer)
    }
    
    private func receiveMessage(_message: P2PMessage) {
        print("👹 \(_message)")
        switch _message.type {
        case .updateBallStateMessage:
            guard let message = UpdateBallStateMessage.fromJson(jsonString: _message.jsonData) else {
                return
            }
            gameState.updateBallState(_ballState: message.ballState)
        case .gameStartMessage:
            self.userRole = Unity.UserRole(rawValue: Int(_message.jsonData)!)
        case .gameFinishMessage:
            gameState.updatePhase(phase: .finished)
        }
    }
}

extension GuestViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //
    }
}



extension GuestViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        permissionRequest = PermissionRequest(
            peerId: peerID,
            onRequest: {
                [weak self] permission in
                invitationHandler(permission, permission ? self?.gameState.session : nil)
            }
        )
    }
}

extension GuestViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //
    }
    
    // sessionを通して送られてくるmessageをViewLogicのmessageReciverに流す
    func session(_ session: MCSession, didReceive data: Data, fromPeer fromPeerID: MCPeerID) {
        //        guard let last = joinedPeers.last, last.peerId == peerID, let message = String(data: data, encoding: .utf8) else {
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
