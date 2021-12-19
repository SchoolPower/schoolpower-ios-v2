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
        static let selectedRadarChartViewingTerm = "selected_radar_chart_viewing_term"
        static let selectedBarChartViewingTerm = "selected_bar_chart_viewing_term"
        static let courseViewingTerm = "course_viewing_term"
        static let lastLoggedInAt = "last_logged_in_at"
        static let lastShownAppStoreReviewPromptAt = "last_shown_app_atore_review_prompt_at"
        static let lastShownAppStoreReviewPromptAppVersion = "last_shown_app_atore_review_prompt_app_version"
        static let appLaunchesCountSinceLastLogin = "app_launches_count_since_last_login"
    }
    
    private static let defaultSettings: [String: Any] = [
        Keys.authenticated: false,
        Keys.username: "",
        Keys.language: Language.systemDefault.rawValue,
        Keys.showInactiveCourses: true,
        Keys.notificationEnabled: true,
        Keys.showGradesInNotification: true,
        Keys.notifyUngradedAssignments: true,
        Keys.dismissedInfoCardUUIDs: [:],
        Keys.studentDataJSON: "",
        Keys.selectedGPACourseIdsByTerm: [:],
        Keys.selectedGPAViewingTerm: "",
        Keys.selectedRadarChartViewingTerm: "",
        Keys.selectedBarChartViewingTerm: "",
        Keys.courseViewingTerm: Term.all,
        Keys.lastLoggedInAt: 0,
        Keys.lastShownAppStoreReviewPromptAt: 0,
        Keys.lastShownAppStoreReviewPromptAppVersion: "",
        Keys.appLaunchesCountSinceLastLogin: 0,
    ]
    
    private let defaults = UserDefaults.standard
    private let cancellable: Cancellable
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private init() {
        defaults.register(defaults: SettingsStore.defaultSettings)
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
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
    var language: Language {
        get {
            defaults
                .string(forKey: Keys.language)
                .flatMap { Language(rawValue: $0) }
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
    
    var courseViewingTerm: Term {
        set { defaults.set(newValue, forKey: Keys.courseViewingTerm) }
        get { defaults.string(forKey: Keys.courseViewingTerm) ?? .all }
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

// MARK: Charts
extension SettingsStore {
    var selectedRadarChartViewingTerm: Term {
        set { defaults.set(newValue, forKey: Keys.selectedRadarChartViewingTerm) }
        get { defaults.string(forKey: Keys.selectedRadarChartViewingTerm) ?? "" }
    }

    var selectedBarChartViewingTerm: Term {
        set { defaults.set(newValue, forKey: Keys.selectedBarChartViewingTerm) }
        get { defaults.string(forKey: Keys.selectedBarChartViewingTerm) ?? "" }
    }
}

// MARK: App Store Review Prompt
extension SettingsStore {
    var lastLoggedInAt: Date {
        set { defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastLoggedInAt) }
        get { Date(timeIntervalSince1970: defaults.double(forKey: Keys.lastLoggedInAt)) }
    }
    
    var lastShownAppStoreReviewPromptAt: Date {
        set { defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastShownAppStoreReviewPromptAt) }
        get { Date(timeIntervalSince1970: defaults.double(forKey: Keys.lastShownAppStoreReviewPromptAt)) }
    }
    
    var lastShownAppStoreReviewPromptAppVersion: String {
        set { defaults.set(newValue, forKey: Keys.lastShownAppStoreReviewPromptAppVersion) }
        get { defaults.string(forKey: Keys.lastShownAppStoreReviewPromptAppVersion) ?? "" }
    }
    
    var appLaunchesCountSinceLastLogin: Int {
        set { defaults.set(newValue, forKey: Keys.appLaunchesCountSinceLastLogin) }
        get { defaults.integer(forKey: Keys.appLaunchesCountSinceLastLogin) }
    }
}
