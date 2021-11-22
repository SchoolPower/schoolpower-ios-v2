//
//  CalendarView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/21/21.
//

import SwiftUI
import KVKCalendar

struct ScheduleView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var courses: [Course]
    
    private var events: [Event] {
        courses
            .flatMap { course in
                course.schedule
                    .map { it in
                        var event = Event(ID: it.id)
                        event.text = course.name
                        event.start = it.startTime.asMillisDate()
                        event.end = it.endTime.asMillisDate()
                        event.color = Event.Color((course.displayGrade()?.color() ?? .F_score_purple).uiColor())
                        return event
                    }
            }
    }
    
    @State private var type: CalendarType = .day
    
    var body: some View {
        NavigationView {
            ZStack {
            GeometryReader { geo in
                CalendarDisplayView(
                    events: events,
                    frame: geo.frame(in: .local),
                    type: type
                )
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                type = horizontalSizeClass == .regular ? .week : .day
            }
            Text("")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker(selection: $type, label: Text("")) {
                            ForEach([
                                CalendarType.day,
                                CalendarType.week,
                            ], id: \.self) { type in
                                Text(LocalizedStringKey(type.rawValue)).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        
    }
}
