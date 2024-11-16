//
//  GameView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct GameView: View {
    @Binding var navigatePath: [NavigationDestination]
    var body: some View {
        VStack(spacing: 30) {
            Text("GameView（ここはクリア or ゲームオーバー）")
            
            Button {
                navigatePath.append(.result)
            } label: {
                Text("ゲームを終了する")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    GameView(navigatePath: .constant([]))
}
