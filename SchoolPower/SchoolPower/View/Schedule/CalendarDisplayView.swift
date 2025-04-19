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
    @Binding var didSelectToday: () -> Void
    @Binding var shouldReloadEvents: Bool
    var didSelectEvent: (String) -> Void

    private var calendar: KVKCalendarView = {
        return KVKCalendarView(
            frame: UIScreen.main.bounds,
            style: Coordinator.defaultStyle,
            years: 2
        )
    }()
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> KVKCalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: KVKCalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        didSelectToday = context.coordinator.didSelectToday
        
        if context.coordinator.frame != frame {
            context.coordinator.frame = frame
        }
        
        if context.coordinator.type != type {
            context.coordinator.type = type
        }
        
        if context.coordinator.locale != locale {
            context.coordinator.locale = locale
        }
        
        if self.shouldReloadEvents {
            context.coordinator.events = events
            self.shouldReloadEvents = false
        }

        if !context.coordinator.initialized {
            context.coordinator.didSelectEvent = didSelectEvent
            context.coordinator.initialized = true
        }
    }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    public init(
        events: [Event],
        frame: CGRect,
        type: CalendarType,
        locale: Locale,
        didSelectToday: Binding<() -> Void>,
        shouldReloadEvents: Binding<Bool>,
        didSelectEvent: @escaping (String) -> Void
    ) {
        self.events = events
        self.frame = frame
        self.type = type
        self.locale = locale
        self._didSelectToday = didSelectToday
        self._shouldReloadEvents = shouldReloadEvents
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
                view.calendar.reloadFrame(frame)
            }
        }
        
        var type: CalendarType = .day {
            didSet {
                view.calendar.set(type: type, date: Date())
                view.calendar.reloadData()
                if !frame.isEmpty {
                    view.calendar.reloadFrame(frame)
                }
            }
        }
        
        var style: Style = Coordinator.defaultStyle
        
        var locale: Locale = Locale.current {
            didSet {
                style.locale = locale
                view.calendar.updateStyle(style)
                view.calendar.reloadData()
            }
        }
        
        var didSelectEvent: (String) -> Void = { _ in }
        
        lazy var didSelectToday: () -> Void = { [self] in
            view.calendar.scrollTo(Date())
            view.calendar.reloadData()
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
            // Highlight for a bit to be responsive
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.calendar.deselectEvent(event, animated: true)
            }
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
            return events
        }
    }
}

