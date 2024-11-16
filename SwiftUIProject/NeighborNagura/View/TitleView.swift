//
//  TitleView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct TitleView: View {
    @State private var navigatePath: [NavigationDestination] = []
    @State private var imageScale: CGFloat = 1.0 // 拡大率を調整するためのState
    @StateObject private var gameState = GameState()

    var body: some View {
        NavigationStack(path: $navigatePath) {
            ZStack {
                Image(.topPage)
                    .resizable()
                    .scaledToFill() // 比率を維持して拡大縮小
                    .frame(width: UIScreen.main.bounds.width * 1.2, // サイズ調整
                           height: UIScreen.main.bounds.height * 1.2)
                    .scaleEffect(imageScale) // 拡大率を適用
                    .clipped() // 外にはみ出る部分をカット
                    .position(x: UIScreen.main.bounds.width / 2, // 真ん中に配置
                              y: UIScreen.main.bounds.height / 2 - 50)

                VStack(spacing: 30) {
                    // タイトルを黒文字に変更
                    Text("ハラハラたいぞうゲーム")
                        .font(Font.custom("Mimi_font-Regular", size: 42))
                        .foregroundColor(.black) // 黒文字に設定

                    // ホストボタン
                    Button {
                        navigatePath.append(.host)
                    } label: {
                        Text("ホスト")
                            .font(Font.custom("Mimi_font-Regular", size: 32))
                            .foregroundColor(.white) // 白文字
                            .padding()
                            .background(Color.black) // 黒背景
                            .cornerRadius(10) // 角丸
                            .padding(.horizontal, 20) // 横方向の余白
                    }

                    // ゲストボタン
                    Button {
                        navigatePath.append(.guest)
                    } label: {
                        Text("ゲスト")
                            .font(Font.custom("Mimi_font-Regular", size: 32))
                            .foregroundColor(.white) // 白文字
                            .padding()
                            .background(Color.black) // 黒背景
                            .cornerRadius(10) // 角丸
                            .padding(.horizontal, 20) // 横方向の余白
                    }
                }
                .padding() // VStack全体を少し余裕を持たせるパディング
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .host: HostView(navigatePath: $navigatePath, gameState: gameState)
                case .guest: GuestView(navigatePath: $navigatePath, gameState: gameState)
                case .game: GameView(navigatePath: $navigatePath, gameState: gameState)
                case .result: ResultView(navigatePath: $navigatePath)
                }
            }
        }
    }
}
