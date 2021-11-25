//
//  CalendarView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/21/21.
//

import SwiftUI
import KVKCalendar

struct CourseModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedCourse: Course?
    
    var body: some View {
        NavigationView {
            DynamicCourseDetailView(course: $selectedCourse)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text("Close")
                        }
                    }
                }
        }
    }
}

struct ScheduleView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Environment(\.locale) private var locale: Locale
    
    var schedule: [Event]
    
    @State private var type: CalendarType = .day
    @State private var selectedCourse: Course? = nil
    @State private var isViewingCourse: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
            GeometryReader { geo in
                ZStack {
                    CalendarDisplayView(
                        events: schedule,
                        frame: geo.frame(in: .local),
                        type: type,
                        locale: locale
                    ) { eventId in
                        let courseId = Course.idFromScheduleEventId(eventId)
                        if let courseId = courseId,
                           let course = StudentDataStore.shared.courseById[courseId] {
                            self.isViewingCourse = true
                            self.selectedCourse = course
                        }
                    }
                    .sheet(isPresented: $isViewingCourse) {
                        self.isViewingCourse = false
                        self.selectedCourse = nil
                    } content: {
                        CourseModal(selectedCourse: $selectedCourse)
                    }
                }
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
