//
//  MemberView.swift
//  UnitySwiftUI
//
//  Created by Taishin Miyamoto on 2024/11/16.
//

import SwiftUI

struct Member: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String

    // デフォルト引数を指定
    init(name: String, iconName: String = "character_yusha_woman_blue") {
        self.name = name
        self.iconName = iconName
    }
}

struct MemberView: View {
    let member: Member

    var body: some View {
        HStack {
            Image(member.iconName) // カスタム画像を使用
                .resizable()
                .frame(width: 40, height: 40)
            
            Text(member.name) // 名前
                .font(Font.custom("Mimi_font-Regular", size: 20))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
