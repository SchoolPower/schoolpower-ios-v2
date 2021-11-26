//
//  SettingsViewModel.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation
import Combine

final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()
    
    internal enum Keys {
        static let authenticated = "authenticated"
        static let username = "username"
        static let language = "language"
        static let showInactiveCourses = "show_inactive_courses"
        static let notificationEnabled = "notifications_enabled"
        static let showGradesInNotification = "show_grades_in_notification"
        static let notifyUngradedAssignments = "notify_ungraded_assignments"
        static let dismissedInfoCardUUIDs = "dismissed_info_card_uuids"
        static let studentDataJSON = "student_data_json"
        static let selectedGPACourseIdsByTerm = "selected_gpa_course_ids_by_term"
        static let selectedGPAViewingTerm = "selected_gpa_viewing_term"
    }
    
    private static let defaultSettings: [String: Any] = [
        Keys.authenticated: false,
        Keys.username: "",
        Keys.language: Constants.Language.systemDefault.rawValue,
        Keys.showInactiveCourses: true,
        Keys.notificationEnabled: true,
        Keys.showGradesInNotification: true,
        Keys.notifyUngradedAssignments: true,
        Keys.dismissedInfoCardUUIDs: [:],
        Keys.studentDataJSON: "",
        Keys.selectedGPACourseIdsByTerm: [:],
        Keys.selectedGPAViewingTerm: "",
    ]
    
    private let defaults = UserDefaults.standard
    private let cancellable: Cancellable
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private init() {
        defaults.register(defaults: SettingsStore.defaultSettings)
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
}


// MARK: Auth
extension SettingsStore {
    var authenticated: Bool {
        set { defaults.set(newValue, forKey: Keys.authenticated) }
        get { defaults.bool(forKey: Keys.authenticated) }
    }
    var username: String? {
        set { defaults.set(newValue, forKey: Keys.username) }
        get { defaults.string(forKey: Keys.username) }
    }
}

// MARK: Language
extension SettingsStore {
    var language: Constants.Language {
        get {
            defaults
                .string(forKey: Keys.language)
                .flatMap { Constants.Language(rawValue: $0) }
            ?? .systemDefault
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.language) }
    }
}

// MARK: Courses
extension SettingsStore {
    var showInactiveCourses: Bool {
        set { defaults.set(newValue, forKey: Keys.showInactiveCourses) }
        get { defaults.bool(forKey: Keys.showInactiveCourses) }
    }
}

// MARK: Notifications
extension SettingsStore {
    var isNotificationEnabled: Bool {
        set { defaults.set(newValue, forKey: Keys.notificationEnabled) }
        get { defaults.bool(forKey: Keys.notificationEnabled) }
    }
    
    var showGradesInNotification: Bool {
        set { defaults.set(newValue, forKey: Keys.showGradesInNotification) }
        get { defaults.bool(forKey: Keys.showGradesInNotification) }
    }
    
    var notifyUngradedAssignments: Bool {
        set { defaults.set(newValue, forKey: Keys.notifyUngradedAssignments) }
        get { defaults.bool(forKey: Keys.notifyUngradedAssignments) }
    }
}

// MARK: InfoCards
extension SettingsStore {
    var dismissedInfoCardUUIDs: [String: Any] {
        set { defaults.set(newValue, forKey: Keys.dismissedInfoCardUUIDs) }
        get { defaults.dictionary(forKey: Keys.dismissedInfoCardUUIDs) ?? [:] }
    }
}

// MARK: StudentData
extension SettingsStore {
    var studentDataJSON: String {
        set { defaults.set(newValue, forKey: Keys.studentDataJSON) }
        get { defaults.string(forKey: Keys.studentDataJSON) ?? "" }
    }
}

// MARK: GPA
extension SettingsStore {
    var selectedGPACourseIdsByTerm: [Term: Any] {
        set { defaults.set(newValue, forKey: Keys.selectedGPACourseIdsByTerm) }
        get { defaults.dictionary(forKey: Keys.selectedGPACourseIdsByTerm) ?? [:] }
    }
    
    var selectedGPAViewingTerm: Term {
        set { defaults.set(newValue, forKey: Keys.selectedGPAViewingTerm) }
        get { defaults.string(forKey: Keys.selectedGPAViewingTerm) ?? "" }
    }
}

