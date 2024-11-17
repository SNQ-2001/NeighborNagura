//
//  GameOverView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct GameOverView: View {
    @Binding var navigatePath: [NavigationDestination]

    var body: some View {
        ZStack {
            // 背景画像
            // 背景画像
            Image(.topPage)
                .resizable()
                .scaledToFill() // 比率を維持して拡大縮小
                .frame(width: UIScreen.main.bounds.width * 1.2, // サイズ調整
                       height: UIScreen.main.bounds.height * 1.2)
                .clipped() // 外にはみ出る部分をカット
                .position(x: UIScreen.main.bounds.width / 2, // 真ん中に配置
                          y: UIScreen.main.bounds.height / 2 - 50)

            // タイトルに戻るボタン
            VStack(spacing: 30) {
                Text("ゲームオーバー")
                    .font(Font.custom("Mimi_font-Regular", size: 42))
                    .foregroundColor(.black) // 黒文字に設定

                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    navigatePath.removeAll() // ナビゲーションスタックをリセット
                } label: {
                    Text("タイトルにもどる")
                        .font(Font.custom("Mimi_font-Regular", size: 32))
                        .foregroundColor(.white) // テキストを白に変更
                        .padding()
                        .background(Color.black) // ボタン背景を黒に変更
                        .cornerRadius(10) // 角を丸める
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
