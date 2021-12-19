//
//  StudentDataStore.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation
import Combine
import Alamofire
import SwiftProtobuf
import KVKCalendar
import UIKit

final class StudentDataStore: ObservableObject {
    static let shared = StudentDataStore()
    
    @Published var studentData: StudentData = StudentData() {
        didSet { self.didSetStudentData() }
    }
    
    @Published var courseById: [String : Course] = [:]
    
    @Published var schedule: [Event] = []
    
    @Published var availableTerms: [Term] = []
    
    private init() {
        loadThenTryFetchAndSave()
    }
    
    func loadThenTryFetchAndSave() {
        StudentDataStore.tryLoadAndIfSuccess { data in self.save(studentData: data) }
        DispatchQueue.main.async {
            StudentDataStore.tryFetchAndIfSuccess(action: .manual) { data in
                self.save(studentData: data)
            }
        }
    }
    
    // MARK: Save
    func save(studentData: StudentData) {
        self.studentData = studentData
        do {
            let dataJsonString = try studentData.jsonString()
            SettingsStore.shared.studentDataJSON = dataJsonString
        } catch {
            print("Failed to save student data: \(error)")
        }
    }
    
    func saveAsync(studentData: StudentData) {
        DispatchQueue.main.async {
            self.save(studentData: studentData)
        }
    }
    
    func refresh(completion: @escaping (Bool, ErrorResponse?, String?) -> Void) {
        if let requestData = AuthenticationStore.shared.requestData {
            StudentDataStore.tryFetch(requestData: requestData, action: .manual) {
                success, data, errorResponse, error in
                if success, let data = data {
                    StudentDataStore.shared.save(studentData: data)
                }
                completion(success, errorResponse, error)
            }
        } else {
            completion(false, ErrorResponse(
                title: "Failed to refresh data".localized,
                description: "No credential available, please try to log in again.".localized
            ), nil)
        }
    }
    
    // MARK: Did set
    private func didSetStudentData() {
        self.schedule = studentData.courses
            .flatMap { course in
                course.schedule
                    .map { it in
                        var event = Event(ID: course.toScheduleEventId(with: it))
                        event.text = scheduleEventText(course, it)
                        event.start = it.startTime.asMillisDate()
                        event.end = it.endTime.asMillisDate()
                        event.color = Event.Color((course.displayGrade()?.color() ?? .F_score_purple).uiColor())
                        return event
                    }
            }
        self.courseById = studentData.courses.reduce(into: [String : Course]()) {
            partialResult, course in
            partialResult[course.id] = course
        }
        self.availableTerms = studentData.extraInfo.availableTerms
        InfoCardStore.shared.load(studentData.extraInfo.informationCard)
    }
}

// MARK: Disabled Info
extension StudentDataStore {
    func disabled() -> Bool {
        return studentData.hasDisabledInfo && (
            !studentData.disabledInfo.title.isEmpty ||
            !studentData.disabledInfo.message.isEmpty
        )
    }
    
    func tryGetDisabledInfo() -> DisabledInfo? {
        return disabled() ? studentData.disabledInfo : nil
    }
}

// MARK: Birthday
extension StudentDataStore {
    func isBirthdayToday() -> Bool {
        let today = Date()
        let dob = studentData.profile.dob.asMillisDate()
        if Utils.isLeapYear(),
           Utils.isSameDayAndMonth(dob, month: 2, day: 29) {
            return Utils.isSameDayAndMonth(today, month: 3, day: 1)
        }
        return Utils.isSameDayAndMonth(dob, today)
    }
    
    func getAge() -> Int {
        let dob = studentData.profile.dob.asMillisDate()
        let today = Date()
        return today.year - dob.year
    }
}

// MARK: Schedule Event
extension StudentDataStore {
    private func scheduleEventText(
        _ course: Course,
        _ schedule: Course.Schedule
    ) -> String {
        let start = schedule.startTime.asMillisDate().time()
        let end = schedule.endTime.asMillisDate().time()
        let time = String(format: "%@-%@", start, end)
        return """
        \(course.name)
        \(time)
        \(course.room)
        """
    }
}

// MARK: Static IO
extension StudentDataStore {
    static func clearLocal() {
        SettingsStore.shared.studentDataJSON = ""
    }
    
    static func tryLoadAndIfSuccess(
        then: @escaping (StudentData) -> Void,
        otherwise: @escaping () -> Void = {}
    ) {
        let dataJsonString = SettingsStore.shared.studentDataJSON
        if !dataJsonString.isEmpty {
            do {
                let data = try StudentData(jsonString: dataJsonString, options: .ignoreUnknown)
                then(data)
            } catch {
                print("Failed to serialize student data from store:" + " \(error)")
                otherwise()
            }
        } else {
            otherwise()
        }
    }
    
    static func tryFetchAndIfSuccess(
        requestData: RequestData? = nil,
        action: GetDataAction,
        then: @escaping (StudentData) -> Void,
        otherwise: @escaping () -> Void = {}
    ) {
        tryFetch(requestData: requestData, action: action) { success, data, errorResponse, error in
            guard success else {
                otherwise()
                return
            }
            if let data = data {
                then(data)
            } else {
                otherwise()
            }
        }
    }
    
    static func tryFetch(
        requestData: RequestData? = AuthenticationStore.shared.requestData,
        action: GetDataAction,
        completion: @escaping (Bool, StudentData?, ErrorResponse?, String?) -> Void
    ) {
        if let requestData = requestData ?? AuthenticationStore.shared.requestData {
            AF.request(
                Constants.getStudentDataURL,
                method: .post,
                parameters: requestData,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders([
                    // e.g. iOS, iPadOS
                    HTTPHeader(
                        name: "X-OS",
                        value: Utils.getOSName()
                    ),
                    // e.g. 15.0
                    HTTPHeader(
                        name: "X-OS-Version",
                        value: UIDevice.current.systemVersion
                    ),
                    // e.g. 2.0.0 (28)
                    HTTPHeader(
                        name: "X-App-Version",
                        value: Utils.getFormattedAppVersionBuild()
                    ),
                    // e.g. manual_pull_data
                    HTTPHeader(
                        name: "X-Action",
                        value: action.rawValue
                    ),
                    // e.g. zh-Hans, zh-Hant-HK, ja_JP, en_CA
                    HTTPHeader(
                        name: "X-Locale",
                        value: Utils.getLocale().identifier
                    ),
                ])
            )
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseString(encoding: .utf8) { response in
                    switch response.result {
                    case .success:
                        guard let jsonString = response.value else { return }
                        debugPrint("JSON fetched")
                        do {
                            let data = try StudentData(jsonString: jsonString, options: .ignoreUnknown)
                            if !data.isValid() {
                                throw JSONDecodingError.missingFieldNames
                            }
                            completion(true, data, nil, nil)
                        } catch {
                            do {
                                let errorResponse = try JSONDecoder()
                                    .decode(ErrorResponse.self, from: jsonString.data(using: .utf8)!)
                                if !errorResponse.hasErrorMessage {
                                    completion(
                                        false, nil, nil,
                                        error.localizedDescription + "\nError: \(error)"
                                    )
                                } else {
                                    completion(false, nil, errorResponse, nil)
                                }
                            } catch {
                                completion(
                                    false, nil, nil,
                                    error.localizedDescription + "\n\(error)"
                                )
                            }
                        }
                    case let .failure(error):
                        completion(false, nil, nil, error.localizedDescription)
                    }
                }
        } else {
            completion(false, nil, nil, nil)
        }
    }
}
