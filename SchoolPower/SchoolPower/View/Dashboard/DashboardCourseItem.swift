//
//  DashboardCourseItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

fileprivate let COMPACT_SUBTITLE_WIDTH_BREAKPOINT: CGFloat = 360
fileprivate let COMPACT_PERCENTAGE_WIDTH_BREAKPOINT: CGFloat = 330

struct GradePercentageView: View {
    var percentage: Double?
    var width: CGFloat
    var color: Color?
    
    var body: some View {
        Text(percentage?.rounded(digits: 0) ?? "--")
            .font(.title2)
            .frame(width: width, height: 80)
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .foregroundColor(color)
                    .cornerRadius(.topRight, 12)
                    .cornerRadius(.bottomRight, 12)
            )
    }
}

struct DashboardCourseItem: View {
    var course: Course
    
    private var color: Color? {
        course.displayGrade()?.color()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                HStack {
                    Text(course.displayGrade()?.letter ?? "--")
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .foregroundColor(course.displayGrade()?.color())
                        )
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
                    .padding(.leading, 8)
                    Spacer()
                }
                .padding(16)
                .background(
                    Rectangle()
                        .foregroundColor(.surface)
                        .frame(height: 80)
                        .cornerRadius(.topLeft, 12)
                        .cornerRadius(.bottomLeft, 12)
                )
                if geometry.size.width < COMPACT_PERCENTAGE_WIDTH_BREAKPOINT {
                    GradePercentageView(percentage: course.displayGrade()?.percentage, width: 50, color: course.displayGrade()?.color())
                } else {
                    GradePercentageView(percentage: course.displayGrade()?.percentage, width: 80, color: course.displayGrade()?.color())
                }
            }
            
        }
        .frame(height: 80)
    }
}

struct DashboardCourseItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardCourseItem(course: fakeCourse)
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}
