//
//  HostView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct HostView: View {
    @Binding var navigatePath: [NavigationDestination]
    
    // ダミーデータ
    let members: [Member] = [
        Member(name: "じゅん"),
        Member(name: "たいぞう"),
        Member(name: "けん")
    ]
    
    var body: some View {
        ZStack {
            // 背景画像
            Image(.topPage)
                .resizable()
                .scaledToFill() // 比率を維持して拡大縮小
                .frame(width: UIScreen.main.bounds.width * 1.2, // サイズ調整
                       height: UIScreen.main.bounds.height * 1.2)
                .clipped() // 外にはみ出る部分をカット
                .position(x: UIScreen.main.bounds.width / 2, // 真ん中に配置
                          y: UIScreen.main.bounds.height / 2 - 50)

            VStack(spacing: 20) {
                // メッセージ
                Text("メンバーを集めています")
                    .font(Font.custom("Mimi_font-Regular", size: 36))
                    .foregroundColor(.white)
                
                // メンバーリスト
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(members, id: \.name) { member in
                            MemberView(member: member) // コンポーネントを利用
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 280)
                .background(Color.white.opacity(0.7))
                .cornerRadius(15)

                // ボタン
                Button {
                    navigatePath.append(.game)
                } label: {
                    Text("ゲームを開始する")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
