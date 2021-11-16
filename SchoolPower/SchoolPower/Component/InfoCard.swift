//
//  InfoCard.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-15.
//

import SwiftUI

struct InfoCard: View {
    var content: InfoCardContent
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(content.localizedTitle).font(.title).bold().fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    Spacer()
                    Button {
                        withAnimation {
                            InfoCardStore.shared.dismiss()
                        }
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
            VStack(alignment: .leading) {
                Text(content.localizedDescription).font(.body).fixedSize(horizontal: false, vertical: true)
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text(content.localizedCTAText).font(.headline).bold()
                    }
                    .buttonStyle(.plain)
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
        List {
            InfoCard(content: fakeInfoCardContent())
            InfoCard(content: fakeLongInfoCardContent())
        }
    }
}
