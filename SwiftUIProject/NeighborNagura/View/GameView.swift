//
//  GameView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct GameView: View {
    @StateObject private var unity = Unity.shared
    @State private var loading = false
    @Binding var navigatePath: [NavigationDestination]
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else if let UnityContainer = unity.view.flatMap({ UIViewContainer(containee: $0) }) {
                UnityContainer.ignoresSafeArea()
            } else {
                Text("エラー。発生していたら報告。")
            }
            
            Button {
                navigatePath.append(.result)
            } label: {
                Text("ゲームを終了する")
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear(perform: handleUnityStart)
        .onDisappear(perform: handleUnityStop)
    }
    
    @MainActor
    private func handleUnityStart() {
        loading = true
        unity.start()
        loading = false
    }
    
    @MainActor
    private func handleUnityStop() {
        loading = true
        unity.stop()
        loading = false
    }
}

#Preview {
    GameView(navigatePath: .constant([]))
}
