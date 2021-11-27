//
//  DashboardViewModel.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    var courses: [Course]
    var disabledInfo: DisabledInfo?
    
    var coursesToDisplay: [Course] {
        if disabledInfo != nil {
            return []
        }
        if !SettingsStore.shared.showInactiveCourses {
            return courses.filter { course in
                !course.grades.isEmpty || !course.assignments.isEmpty
            }
        }
        return courses
    }
    
    var showPlaceholder: Bool {
        (disabledInfo != nil || coursesToDisplay.isEmpty)
    }
    
    var placeholder: some View {
        if let disabledInfo = disabledInfo {
            return AnyView(DisabledInfoView(disabledInfo: disabledInfo)
                            .userInteractionDisabled())
        } else {
            return AnyView(NoGradesView()
                            .userInteractionDisabled())
        }
    }
    
    init(courses: [Course], disabledInfo: DisabledInfo?) {
        self.courses = courses
        self.disabledInfo = disabledInfo
    }
}
