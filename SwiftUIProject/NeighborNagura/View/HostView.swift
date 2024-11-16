//
//  HostView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct HostView: View {
    @Binding var navigatePath: [NavigationDestination]
    @ObservedObject var gameState: GameState
    @StateObject private var hostViewModel: HostViewModel
    @State var showNotPreparedAleart = false
    
    init(navigatePath: Binding<[NavigationDestination]>, gameState: GameState) {
        self._navigatePath = navigatePath
        self.gameState = gameState
        self._hostViewModel = .init(wrappedValue: .init(gameState: gameState))
    }
    
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
                        ForEach(hostViewModel.peers, id: \.peerId) { member in
                            MemberView(member: Member(name: member.peerId.displayName)) // コンポーネントを利用
                                .onTapGesture {
                                    hostViewModel.invite(_selectedPeer: PeerDevice(peerId: member.peerId))
                                }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 280)
                .background(Color.white.opacity(0.7))
                .cornerRadius(15)

                // ボタン
                Button {
                    if (!hostViewModel.join()) {
                        showNotPreparedAleart = true
                        return
                    }
                    hostViewModel.sendGameStartMessage()
                    navigatePath.append(.game)
                } label: {
                    Text("ゲームを開始する")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .foregroundColor(.white) // 白文字に設定
                        .padding() // 内側に余白を追加
                        .frame(maxWidth: .infinity) // 横幅を最大に調整
                        .background(Color.black) // 背景を黒に設定
                        .cornerRadius(10) // 角を丸くする
                        .padding(.horizontal, 20) // 横方向に余白を追加
                }

            }
            .padding()
        }
        .alert(isPresented: $showNotPreparedAleart, content: {
            Alert(
                title: Text("まだ準備できてないよん"),
                primaryButton: .default(Text("わかった"), action: {
                    showNotPreparedAleart = false
                }),
                secondaryButton: .cancel(Text("ちょっと待つよ"), action: {
                    showNotPreparedAleart = false
                })
            )
        })
    }
}
