//
//  BarChartStatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import SwiftUI

struct BarChartStatisticsView: View {
    var courses: [Course]
    
    var body: some View {
//        RadarChart(data: courses.filterHasGrades().compactMap({ it in
//            it.displayGrade()?.percentage
//        }))
        VStack {
            BarChart(courses: courses).padding(.vertical)
        }
        .padding()
        .toolbar {
            EditButton()
        }
        .navigationTitle("Bar Chart")
    }
}

struct BarChartStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartStatisticsView(courses: [fakeCourse(), fakeCourse(), fakeCourse()])
    }
}
