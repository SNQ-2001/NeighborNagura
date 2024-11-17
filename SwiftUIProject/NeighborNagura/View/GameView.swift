//
//  GameView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI
import CoreMotion

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
        .onAppear {
            if case .game(let userRole) = navigatePath.last {
                switch userRole {
                case .host:
                    unity.userRole = .host
                case .client1:
                    unity.userRole = .client1
                case .client2:
                    unity.userRole = .client2
                case .client3:
                    unity.userRole = .client3
                }
            }
        }
        .overlay{
            Text("ユーザー: \(unity.userRole.rawValue)")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding()
        }
        .onAppear(perform: handleUnityStart)
        .onDisappear(perform: handleUnityStop)
        .onChange(of: motion.accelerometerData?.acceleration) {
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
        .onChange(of: unity.isGameClear) {
            if unity.isGameClear {
                unity.isGameClear = false
                navigatePath.append(.gameClear)
            }
        }
        .onChange(of: unity.isGameOver) {
            if unity.isGameOver {
                unity.isGameOver = false
                navigatePath.append(.gameOver)
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

extension CMAcceleration: @retroactive Equatable {
    public static func == (lhs: CMAcceleration, rhs: CMAcceleration) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
