//
//  InfoCard.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-15.
//

import SwiftUI

struct InfoCard: View {
    var content: InformationCard
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(content.title).font(.title).bold().fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                        .padding(.vertical)
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
                    AsyncImageView(imageURL: URL(string: content.imageURL)!, contentMode: .fit)
                        .clipped()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hexString: content.titleBackgroundColorHex))
            VStack(alignment: .leading) {
                Text(content.message).font(.body).fixedSize(horizontal: false, vertical: true)
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.open(
                            URL(string: content.primaryOnClickURL)!)
                    }) {
                        Text(content.primaryText).font(.headline).bold()
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
            .background(Color(hexString: content.messageBackgroundColorHex))
        }
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(content: fakeInformationCard())
    }
}
