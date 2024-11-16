//
//  HostView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct HostView: View {
    @Binding var navigatePath: [NavigationDestination]
    var body: some View {
        VStack(spacing: 30) {
            Text("HostView（ここでマッチングを行う）")
            
            Button {
                navigatePath.append(.game)
            } label: {
                Text("ゲームを開始する（仮）（ここでマッチングを行う）")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    HostView(navigatePath: .constant([]))
}
