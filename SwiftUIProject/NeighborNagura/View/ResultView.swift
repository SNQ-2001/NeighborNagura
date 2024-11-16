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
        VStack(spacing: 30) {
            Text("ResultView")
            
            Text("ここに結果が表示されます")
            
            Button {
                navigatePath.removeAll()
            } label: {
                Text("タイトルに戻る")
            }
        }
        .navigationBarBackButtonHidden()
    }
}
