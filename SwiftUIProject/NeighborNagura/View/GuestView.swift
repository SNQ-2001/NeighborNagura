//
//  GuestView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct GuestView: View {
    @Binding var navigatePath: [NavigationDestination]

    var body: some View {
        ZStack {
            Image(.topPage)
                .resizable()
                .scaledToFill() // 比率を維持して拡大縮小
                .frame(width: UIScreen.main.bounds.width * 1.2, // サイズ調整
                       height: UIScreen.main.bounds.height * 1.2)
                .clipped() // 外にはみ出る部分をカット
                .position(x: UIScreen.main.bounds.width / 2, // 真ん中に配置
                          y: UIScreen.main.bounds.height / 2 - 50)

            // 中央のメッセージ
            Text("ホストがゲームを開始するのを\nまっています")
                .font(Font.custom("Mimi_font-Regular", size: 24))
                .foregroundColor(.black) // 黒文字
                .multilineTextAlignment(.center) // 複数行の場合中央揃え
                .padding(.horizontal, 20) // 横方向に余裕を追加
        }
        .navigationBarBackButtonHidden() // 戻るボタンを非表示
    }
}
