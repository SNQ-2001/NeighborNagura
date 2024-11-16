//
//  PeerDevice.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import Foundation
import MultipeerConnectivity

struct PeerDevice: Identifiable, Hashable {
    let id = UUID()
    let peerId: MCPeerID
}
