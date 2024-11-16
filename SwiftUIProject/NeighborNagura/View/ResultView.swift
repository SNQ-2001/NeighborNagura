//
//  ResultView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct ResultView: View {
    @Binding var navigatePath: [NavigationDestination]

    var body: some View {
        ZStack {
            // 背景画像
            Image(.topPage) // アセットカタログ内の背景画像を指定
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // セーフエリアを無視して全画面に表示

            // タイトルに戻るボタン
            VStack {
                Spacer()
                Button {
                    navigatePath.removeAll() // ナビゲーションスタックをリセット
                } label: {
                    Text("タイトルにもどる")
                        .font(Font.custom("Mimi_font-Regular", size: 32))
                        .foregroundColor(.white) // テキストを白に変更
                        .padding()
                        .background(Color.black) // ボタン背景を黒に変更
                        .cornerRadius(10) // 角を丸める
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(navigatePath: .constant([]))
}
