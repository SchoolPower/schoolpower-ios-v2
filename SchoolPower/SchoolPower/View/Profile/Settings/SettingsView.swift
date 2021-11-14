//
//  SettingsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        Form {
            Section() {
                Picker(
                    selection: $settings.language,
                    label: Text("Language")
                ) {
                    ForEach(Constants.Language.allCases, id: \.self) { language in
                        Text(LocalizedStringKey(language.rawValue)).tag(language)
                    }
                }
            }
            Section(
                footer: Text("Show courses with no assignment or grade.")
            ) {
                Toggle(isOn: $settings.showInactiveCourses) {
                    Text("Show Inactive Courses")
                }
            }
            Section() {
                Toggle(isOn: $settings.isNotificationEnabled) {
                    Text("Enable Notification")
                }
                Toggle(isOn: $settings.showGradesInNotification) {
                    Text("Show Grades in Notification")
                }
                .disabled(!settings.isNotificationEnabled)
                Toggle(isOn: $settings.notifyUngradedAssignments) {
                    Text("Notify Ungraded Assignments")
                }
                .disabled(!settings.isNotificationEnabled)
            }
            SupportSection()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsStore.shared)
    }
}
