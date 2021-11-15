//
//  InfoCard.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-15.
//

import SwiftUI

struct InfoCard: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text("プロジェクトセカイ").font(.title).bold().fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    Spacer()
                    Button {
                        print("aaa")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
                HStack {
                    Image("test_illus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .aspectRatio(1.5, contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hexString: "#C3B9A9"))
            VStack {
                HStack {
                    Text("フィチャリングハツネミク").font(.body)
                    Spacer()
                    Button(action: {}) {
                        Text("プレイ").font(.headline).bold()
                    }
                    .padding(6)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .foregroundColor(.accentColor)
                    .cornerRadius(64)
                    .padding(.leading, 16)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hexString: "#AE9F90"))
        }
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard()
            .previewLayout(.fixed(width: 300, height: 400))
    }
}
