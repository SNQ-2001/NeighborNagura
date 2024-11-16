//
//  GameView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct GameView: View {
    @StateObject private var unity = Unity.shared
    @StateObject private var motion = Motion()
    @State private var loading = false
    @Binding var navigatePath: [NavigationDestination]
    @ObservedObject var gameState: GameState
    @StateObject private var gameViewModel = GameViewModel()
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else if let unityView = unity.view.flatMap({ UIViewContainer(containee: $0) }) {
                unityView.ignoresSafeArea()
            } else {
                Text("エラー。発生していたら報告。")
            }
        }
        .onAppear(perform: handleUnityStart)
        .onDisappear(perform: handleUnityStop)
        .onChange(of: motion.accelerometerData?.acceleration.x) {
            if let x = motion.accelerometerData?.acceleration.x {
                unity.x = x
            }
        }
        .onChange(of: motion.accelerometerData?.acceleration.y) {
            if let y = motion.accelerometerData?.acceleration.y {
                unity.y = y
            }
        }
        .onChange(of: motion.accelerometerData?.acceleration.z) {
            if let z = motion.accelerometerData?.acceleration.z {
                unity.z = z
            }
        }
        .onChange(of: gameState.phase) {
            if (gameState.phase == .finished) {
                navigatePath.append(.result)
            }
        }
        .onChange(of: unity.isGameClear) {
            if unity.isGameClear {
                unity.isGameClear = false
                // TODO: リザルトに情報を持たせる必要があるかも（そうするとゲームクリアとゲームオーバーで分岐せずに済む）
                gameViewModel.gameFinish(gameState: gameState)
            }
        }
        .onChange(of: unity.isGameOver) {
            if unity.isGameOver {
                unity.isGameOver = false
                // TODO: リザルトに情報を持たせる必要があるかも（そうするとゲームクリアとゲームオーバーで分岐せずに済む）
                gameViewModel.gameFinish(gameState: gameState)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func handleUnityStart() {
        motion.startAccelerometerUpdates()
        loading = true
        unity.start()
        loading = false
    }
    
    private func handleUnityStop() {
        motion.stopUpdates()
        loading = true
        unity.stop()
        loading = false
    }
}
