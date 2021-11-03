//
//  InfoItem.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import SwiftUI



struct InfoItem: View {
    var leadingCircleText: String?
    var label: String
    var text: String
    var body: some View {
        HStack {
            if (leadingCircleText != nil) {
                Text(leadingCircleText!)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .foregroundColor(.purple)
                    )
                Spacer().frame(width: 16).fixedSize()
            }
            VStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(.primary)
                    .font(.caption)
                Spacer().frame(height: 6).fixedSize()
                Text(text)
                    .foregroundColor(.primary)
                    .font(.body)
                    .bold()
            }
        }
        .frame(height: 70)
    }
}

struct InfoItem_Previews: PreviewProvider {
    static var previews: some View {
        InfoItem(
            leadingCircleText: "A",
            label: "Title",
            text: "Text"
        )
        .frame(width: 383, height: 70)
        .previewLayout(.fixed(width: 383, height: 70))
    }
}
