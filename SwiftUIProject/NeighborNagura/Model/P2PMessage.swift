//
//  P2PMessage.swift
//  NeighborHarada
//
//  Created by shunsuke tamura on 2024/11/16.
//

import Foundation

enum MessageType: Int, Codable {
    case updateBallStateMessage = 0
}

class P2PMessage: Codable {
    var type: MessageType
    var jsonData: String
    
    init(type: MessageType, jsonData: String) {
        self.type = type
        self.jsonData = jsonData
    }
    
    func toSendMessage() -> String {
        return "\(type.rawValue):::\(jsonData)"
    }
    
    static func fromReceivedMessage(message: String) -> P2PMessage? {
        let components = message.components(separatedBy: ":::")
        guard components.count == 2 else {
            print("Failed to split message: \(message)")
            return nil
        }
        
        guard let type = MessageType(rawValue: Int(components[0]) ?? -1) else {
            print("Failed to convert message type: \(components[0])")
            return nil
        }
        
        return P2PMessage(type: type, jsonData: components[1])
    }
}

class UpdateBallStateMessage:Codable {
    var ballState: BallState
    
    init(ballState: BallState) {
        self.ballState = ballState
    }
    
    func toJson() -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to encode Message to JSON: \(error)")
            return nil
        }
    }
    
    static func fromJson(jsonString: String) -> UpdateBallStateMessage? {
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data.")
            return nil
        }
        
        do {
            let state = try decoder.decode(UpdateBallStateMessage.self, from: jsonData)
            return state
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
