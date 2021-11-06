//
//  DashboardCourseItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

fileprivate let COMPACT_SUBTITLE_WIDTH_BREAKPOINT: CGFloat = 360
fileprivate let COMPACT_PERCENTAGE_WIDTH_BREAKPOINT: CGFloat = 330

fileprivate struct GradePercentageView: View {
    var percentage: Double?
    var width: CGFloat
    var color: Color?
    
    var body: some View {
        Text(percentage?.rounded(digits: 0) ?? "--")
            .font(.title3)
            .frame(width: width, height: 40)
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .foregroundColor(color)
                    .cornerRadius(20)
            )
            .padding(.trailing)
    }
}

struct DashboardCourseItem: View {
    var course: Course
    
    private var color: Color? {
        course.displayGrade().color()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                HStack {
                    if geometry.size.width >= COMPACT_PERCENTAGE_WIDTH_BREAKPOINT {
                        Text(course.displayGrade()?.letter ?? "--")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .foregroundColor(color)
                            )
                            .padding(.trailing, 8)
                    }
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .foregroundColor(.primary)
                            .font(.headline)
                        Spacer().frame(height: 8).fixedSize()
                        HStack {
                            if (geometry.size.width >= COMPACT_SUBTITLE_WIDTH_BREAKPOINT) {
                                Text("Block").font(.caption).opacity(0.6)
                                    .foregroundColor(.primary)
                            }
                            Text(course.block)
                                .font(.caption)
                                .foregroundColor(.primary)
                            if (geometry.size.width >= COMPACT_SUBTITLE_WIDTH_BREAKPOINT) {
                                Text("Room").font(.caption).opacity(0.6)
                                    .padding(.leading, 8)
                                    .foregroundColor(.primary)
                            }
                            Text(course.room)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                }
                .padding(16)
                if geometry.size.width < COMPACT_PERCENTAGE_WIDTH_BREAKPOINT {
                    GradePercentageView(percentage: course.displayGrade()?.percentage, width: 50, color: color)
                } else {
                    GradePercentageView(percentage: course.displayGrade()?.percentage, width: 70, color: color)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .frame(height: 96, alignment: .center)
    }
}

struct DashboardCourseItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardCourseItem(course: fakeCourse())
        }
        .previewLayout(.fixed(width: 383, height: 96))
    }
}
