//
//  RadarChart.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/26/21.
//

import SwiftUI
import Charts

struct RadarChart: UIViewRepresentable {
    let courses: [Course]
    
    private var coursesWithGrades: [Course] {
        courses.filterHasGrades()
    }
    
    private var coursesNames: [String] {
        coursesWithGrades.map { it in it.name.softBreakEvery(5, hardBreak: 12) }
    }
    
    private var entries: [RadarChartDataEntry] {
        coursesWithGrades
            .compactMap { it in it.displayGrade()?.percentage }
            .enumerated()
            .map { (index, percentage) in
                RadarChartDataEntry(
                    value: percentage,
                    data: index
                )
            }
    }
    
    func makeUIView(context: Context) -> RadarChartView {
        return RadarChartView()
    }
    
    func updateUIView(_ uiView: RadarChartView, context: Context) {
        let dataSet = RadarChartDataSet(entries: entries)
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        dataSet.valueFont = .systemFont(ofSize: 10)
        dataSet.colors = [Color.accent.uiColor()]
        dataSet.fillColor = Color.accent.uiColor()
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.5
        dataSet.lineWidth = 2.0
        dataSet.setDrawHighlightIndicators(false)
        
        uiView.data = RadarChartData(dataSet: dataSet)
        uiView.legend.enabled = false
        
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        uiView.noDataText = "No Data".localized
        
        uiView.yAxis.labelFont = .systemFont(ofSize: 0)
        uiView.yAxis.labelCount = 5
        uiView.yAxis.axisMinimum = 0
        uiView.yAxis.axisMaximum = 100
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: coursesNames)
        uiView.extraTopOffset = 100
        uiView.extraLeftOffset = 75
        uiView.extraRightOffset = 75
    }
}

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        RadarChart(
            courses: (1..<12).map { _ in fakeCourse() }
        )
    }
}
