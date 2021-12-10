//
//  BarChartView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import SwiftUI
import Charts

struct BarChart: UIViewRepresentable {
    let courses: [Course]
    
    private var coursesWithGrades: [Course] {
        courses.filterHasGrades()
    }
    
    private var coursesNames: [String] {
        coursesWithGrades.map { it in it.name }
    }
    
    private var entries: [BarChartDataEntry] {
        coursesWithGrades
            .compactMap { it in it.displayGrade()?.percentage }
            .enumerated()
            .map { (index, percentage) in
                BarChartDataEntry(
                    x: Double(index),
                    y: percentage
                )
            }
    }
    
    func makeUIView(context: Context) -> BarChartView {
        return BarChartView()
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        dataSet.colors = dataSet.entries.map({ it in
            it.y.toLetterGrade().getLetterGradeColor().uiColor()
        })
        dataSet.valueFont = .systemFont(ofSize: 10)
        
        uiView.data = entries.isEmpty ? nil : BarChartData(dataSet: dataSet)
        
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        uiView.noDataText = "No Data".localized
        uiView.noDataFont = .systemFont(ofSize: 24)
        uiView.noDataTextColor = Color.gray.uiColor()
        uiView.rightAxis.enabled = true
        uiView.rightAxis.labelFont = .systemFont(ofSize: 0)
        uiView.rightAxis.granularity = 1
        uiView.rightAxis.axisMinimum = 0
        uiView.rightAxis.axisMaximum = 100
        uiView.highlightPerTapEnabled = false
        uiView.highlightPerDragEnabled = false
        uiView.legend.enabled = false
        uiView.xAxis.drawGridLinesEnabled = false
        uiView.leftAxis.drawGridLinesEnabled = true
        uiView.setVisibleXRangeMinimum(1)
        uiView.setVisibleYRangeMinimum(5, axis: .left)
        
        uiView.extraTopOffset = 15
        uiView.extraBottomOffset = 25
        uiView.leftAxis.axisMinimum = 0
        uiView.leftAxis.axisMaximum = 100
        uiView.leftAxis.granularity = 1
        uiView.xAxis.labelPosition = .bottom
        uiView.xAxis.labelHeight = 100
        uiView.xAxis.wordWrapEnabled = true
        uiView.xAxis.wordWrapWidthPercent = 0.8
        uiView.xAxis.granularity = 1
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: coursesNames)
        uiView.animate(yAxisDuration: 0.75, easingOption: .easeInOutQuart)
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(
            courses: (1..<12).map { _ in fakeCourse() }
        )
    }
}
