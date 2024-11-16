//
//  PermissionRequest.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import MultipeerConnectivity

struct PermissionRequest: Identifiable {
    let id = UUID()
    let peerId: MCPeerID
    let onRequest: (Bool) -> Void
}
