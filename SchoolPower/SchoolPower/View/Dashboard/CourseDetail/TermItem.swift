//
//  TermItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

struct TermItem: View {
    var termGrade: TermGrade
    
    var body: some View {
        VStack(spacing: 2) {
            Text(termGrade.term.string())
                .foregroundColor(.primary)
                .font(.body)
                .bold()
            Text(termGrade.grade.percentage.rounded(digits: 0))
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .foregroundColor(termGrade.grade.color())
                )
        }
        .padding(16)
        .background(
            Rectangle()
                .foregroundColor(.surface)
                .frame(width: 65, height: 80)
                .cornerRadius(12)
        )
        .frame(width: 65, height: 80)
    }
}
