//
//  CalendarDisplayView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/21/21.
//

import SwiftUI
import KVKCalendar
import EventKit

struct CalendarDisplayView: UIViewRepresentable {
    var events: [Event]
    var frame: CGRect
    var type: CalendarType
    var style: Style = Style()

    private var calendar: CalendarView = {
        return CalendarView(frame: UIScreen.main.bounds, style: Coordinator.defaultStyle)
    }()
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        context.coordinator.events = events
        context.coordinator.frame = frame
        context.coordinator.type = type
    }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    public init(
        events: [Event],
        frame: CGRect,
        type: CalendarType
    ) {
        self.events = events
        self.frame = frame
        self.type = type
    }
    
    // MARK: Calendar DataSource and Delegate
    class Coordinator: NSObject, CalendarDataSource, CalendarDelegate {
        private let view: CalendarDisplayView
        
        static let defaultStyle: Style = {
            var style = Style()
            style.startWeekDay = .sunday
            style.headerScroll.heightHeaderWeek = 80
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.colorBackground = .systemBackground
            style.timeline.isHiddenStubEvent = true
            return style
        }()
        
        var events: [Event] = [] {
            didSet {
                view.calendar.reloadData()
            }
        }
        
        var frame: CGRect = CGRect() {
            didSet {
                view.calendar.reloadFrame(frame)
            }
        }
        
        var type: CalendarType = .day {
            didSet {
                view.calendar.set(type: type, date: Date())
                view.calendar.reloadData()
            }
        }
        
        var style: Style = Coordinator.defaultStyle {
            didSet {
                view.calendar.updateStyle(style)
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
            super.init()
        }
        
        func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
            self.view.calendar.reloadData()
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
            return events
        }
    }
}

