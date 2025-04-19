//
//  RadarChart.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/26/21.
//

import SwiftUI
import DGCharts

struct RadarChart: UIViewRepresentable {
    let courses: [Course]
    let frame: CGRect
    
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        let dataSet = RadarChartDataSet(entries: entries)
        dataSet.valueFont = .systemFont(ofSize: 10)
        dataSet.colors = [Color.accent.uiColor()]
        dataSet.fillColor = Color.accent.uiColor()
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.5
        dataSet.lineWidth = 2.0
        dataSet.setDrawHighlightIndicators(false)
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        uiView.data = entries.isEmpty ? nil : RadarChartData(dataSet: dataSet)
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: coursesNames)
        
        uiView.legend.enabled = false
        uiView.noDataText = "No Data".localized
        uiView.noDataFont = .systemFont(ofSize: 24)
        uiView.noDataTextColor = Color.gray.uiColor()
        uiView.yAxis.labelCount = 5
        uiView.yAxis.axisMinimum = 0
        uiView.yAxis.axisMaximum = 100
        uiView.yAxis.labelFont = .systemFont(ofSize: 0)
        uiView.extraTopOffset = 100
        uiView.extraLeftOffset = 75
        uiView.extraRightOffset = 75
        
        uiView.notifyDataSetChanged()
        uiView.renderer = RadarChartRenderer(
            chart: uiView,
            animator: uiView.chartAnimator,
            viewPortHandler: uiView.viewPortHandler
        )
        uiView.notifyDataSetChanged()
        uiView.animate(yAxisDuration: 0.75, easingOption: .easeInOutQuart)
    }
}

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            RadarChart(
                courses: [],
                frame: geo.frame(in: .local)
            )
        }
        .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
