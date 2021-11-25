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
    var locale: Locale
    var didSelectEvent: (String) -> Void

    private var calendar: CalendarView = {
        return CalendarView(
            frame: UIScreen.main.bounds,
            style: Coordinator.defaultStyle
        )
    }()
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> CalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: CalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        if context.coordinator.type != type {
            context.coordinator.type = type
        }
        
        if context.coordinator.frame != frame {
            context.coordinator.frame = frame
        }
        
        if context.coordinator.locale != locale {
            context.coordinator.locale = locale
        }
        
        if !context.coordinator.initialized {
            context.coordinator.events = events
            context.coordinator.didSelectEvent = didSelectEvent
            context.coordinator.initialized = true
        }
        
        context.coordinator.maybeReload()
    }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    public init(
        events: [Event],
        frame: CGRect,
        type: CalendarType,
        locale: Locale,
        didSelectEvent: @escaping (String) -> Void
    ) {
        self.events = events
        self.frame = frame
        self.type = type
        self.locale = locale
        self.didSelectEvent = didSelectEvent
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
        
        var initialized: Bool = false
        
        var shouldReloadFrame: Bool = false
        
        var events: [Event] = [] {
            didSet {
                view.calendar.reloadData()
            }
        }
        
        var frame: CGRect = CGRect() {
            didSet {
                shouldReloadFrame = true
            }
        }
        
        var type: CalendarType = .day {
            didSet {
                view.calendar.set(type: type, date: Date())
                shouldReloadFrame = true
            }
        }
        
        var style: Style = Coordinator.defaultStyle {
            didSet {
                view.calendar.updateStyle(style)
            }
        }
        
        var locale: Locale = Locale.current {
            didSet {
                style.locale = locale
            }
        }
        
        var didSelectEvent: (String) -> Void = { _ in }
        
        func maybeReload() {
            if shouldReloadFrame {
                DispatchQueue.main.async { [self] in
                    view.calendar.reloadFrame(frame)
                    view.calendar.reloadData()
                    shouldReloadFrame = false
                }
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
            super.init()
        }
        
        func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
            self.view.calendar.reloadData()
        }
        
        func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
            self.didSelectEvent(event.ID)
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
            return events
        }
    }
}

