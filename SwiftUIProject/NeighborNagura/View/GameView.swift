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
        .onChange(of: [
            motion.accelerometerData?.acceleration.x,
            motion.accelerometerData?.acceleration.y,
            motion.accelerometerData?.acceleration.z
        ]) {
            switch unity.userRole {
            case .host:
                guard let accelerometerData = motion.accelerometerData else {
                    return
                }
                unity.ballAcceleration = .init(
                    x: accelerometerData.acceleration.x,
                    y: accelerometerData.acceleration.y,
                    z: accelerometerData.acceleration.z
                )
                gameViewModel.sendGameBallAccelerationMessage(
                    session: gameState.session!,
                    ballAcceleration: .init(
                        x: accelerometerData.acceleration.x,
                        y: accelerometerData.acceleration.y,
                        z: accelerometerData.acceleration.z
                    )
                )
            case .client1, .client2, .client3:
                return
            }
        }
        .onChange(of: gameState.ballAcceleration) {
            if unity.userRole != .host {
                unity.ballAcceleration = gameState.ballAcceleration
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
        if unity.userRole == .host {
            motion.startAccelerometerUpdates()
        }
        loading = true
        unity.start()
        loading = false
    }
    
    private func handleUnityStop() {
        if unity.userRole == .host {
            motion.stopUpdates()
        }
        loading = true
        unity.stop()
        loading = false
    }
}
