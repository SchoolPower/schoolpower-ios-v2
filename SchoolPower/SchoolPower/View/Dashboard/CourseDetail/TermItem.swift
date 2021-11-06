//
//  TermItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

struct TermItem: View {
    var termGrade: Model_TermGrade
    
    var body: some View {
        VStack(spacing: 2) {
            Text(termGrade.term)
                .foregroundColor(.white)
                .font(.body)
                .bold()
            Text(termGrade.grade.percentage.rounded(digits: 0))
                .frame(width: 40, height: 40)
                .foregroundColor(termGrade.grade.color())
                .background(
                    Circle()
                        .foregroundColor(.white)
                )
        }
        .padding(16)
        .background(
            Rectangle()
                .foregroundColor(termGrade.grade.color())
                .frame(width: 65, height: 80)
                .cornerRadius(12)
        )
        .frame(width: 65, height: 80)
    }
}

struct TermItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TermItem(termGrade: fakeTermGrade())
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}
