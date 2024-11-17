import SwiftUI

struct GameClearView: View {
    @Binding var navigatePath: [NavigationDestination]
    @State private var gateScale: CGFloat = 1 // 左右と中央門の拡大率を共通で管理
    @State private var leftOffset: CGFloat = 0
    @State private var rightOffset: CGFloat = 0
    @State private var monOpacity: Double = 1
    @State private var showTreasure: Bool = false

    var body: some View {
        ZStack {
            // 背景色
            Color.black.ignoresSafeArea()

            // 宝物の画像
            if showTreasure {
                VStack {
                    Image("treasure")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400) // 元のサイズの1.5倍
                        .transition(.scale)
                        .zIndex(0) // 一番後ろに配置
                    
                    Button {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        navigatePath.removeAll() // ナビゲーションスタックをリセット
                    } label: {
                        Text("タイトルにもどる")
                            .font(Font.custom("Mimi_font-Regular", size: 32))
                            .foregroundColor(.black) // テキストを白に変更
                            .padding()
                            .background(Color.white) // ボタン背景を黒に変更
                            .cornerRadius(10) // 角を丸める
                    }
                }
            }

            // 中央の門
            Image("treasure_mon")
                .resizable()
                .scaledToFit()
                .frame(width: 620, height: 600) // サイズを大きく調整
                .scaleEffect(gateScale)
                .opacity(monOpacity)
                .zIndex(2) // 門を手前に配置

            // 左側の門
            Image("treasure_left")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 600) // サイズを大きく調整
                .scaleEffect(gateScale)
                .offset(x: leftOffset)
                .zIndex(1)

            // 右側の門
            Image("treasure_right")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 600) // サイズを大きく調整
                .scaleEffect(gateScale)
                .offset(x: rightOffset)
                .zIndex(1)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            performAnimation()
        }
    }

    private func performAnimation() {
        // 左右の門がスライドして開くアニメーション
        withAnimation(.easeInOut(duration: 2)) {
            leftOffset = -400 // 左方向にスライド（2倍に調整）
            rightOffset = 400 // 右方向にスライド（2倍に調整）
        }

        // 中央の門が拡大してフェードアウト
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.5)) {
                gateScale = 1.5 // 拡大率を調整
                monOpacity = 0 // フェードアウト
            }
        }

        // 宝物を表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 1.5)) {
                showTreasure = true
            }
        }
    }
}
