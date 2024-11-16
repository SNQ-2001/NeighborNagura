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

    var body: some View {
        NavigationStack(path: $navigatePath) {
            ZStack {
                // 背景画像の配置
                if let imagePath = Bundle.main.path(forResource: "top-page-image", ofType: "png"),
                   let uiImage = UIImage(contentsOfFile: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill() // 比率を維持して拡大縮小
                        .frame(width: UIScreen.main.bounds.width * 1.2, // サイズ調整
                               height: UIScreen.main.bounds.height * 1.2)
                        .scaleEffect(imageScale) // 拡大率を適用
                        .clipped() // 外にはみ出る部分をカット
                        .position(x: UIScreen.main.bounds.width / 2, // 真ん中に配置
                                  y: UIScreen.main.bounds.height / 2 - 50)
                } else {
                    // 画像が見つからない場合のプレースホルダー
                    Color.red
                        .overlay(Text("画像が見つかりません")
                            .foregroundColor(.white))
                        .ignoresSafeArea()
                }

                VStack(spacing: 30) {
                    Text("ハラハラたいぞうゲーム")
                        .font(Font.custom("Mimi_font-Regular", size: 42))
                        .foregroundColor(.white)

                    Button {
                        navigatePath.append(.host)
                    } label: {
                        Text("ホスト")
                        .font(Font.custom("Mimi_font-Regular", size: 32))
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        navigatePath.append(.guest)
                    } label: {
                        Text("ゲスト")
                        .font(Font.custom("Mimi_font-Regular", size: 32))
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding() // VStack全体を少し余裕を持たせるパディング
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .host: HostView(navigatePath: $navigatePath)
                case .guest: GuestView(navigatePath: $navigatePath)
                case .game: GameView(navigatePath: $navigatePath)
                case .result: ResultView(navigatePath: $navigatePath)
                }
            }
        }
    }
}

#Preview {
    TitleView()
}
