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

final class StudentDataStore: ObservableObject {
    static let shared = StudentDataStore()
    
    @Published var studentData: StudentData = StudentData()
    
    private init() {
        loadThenTryFetchAndSave()
    }
    
    func loadThenTryFetchAndSave() {
        StudentDataStore.tryLoadAndIfSuccess { data in self.studentData = data }
        StudentDataStore.tryFetchAndIfSuccess { data in
            self.save(studentData: data)
            
        }
    }
    
    func save(studentData: StudentData) {
        self.studentData = studentData
        do {
            let dataJsonString = try studentData.jsonString()
            Utils.saveStringToFile(filename: Constants.studentDataFileName, data: dataJsonString)
        } catch {
            print("Failed to save student data to file:" + " \(Constants.studentDataFileName): \(error)")
        }
    }
    
    func saveAsync(studentData: StudentData) {
        DispatchQueue.main.async {
            self.save(studentData: studentData)
        }
    }
    
    func refresh(completion: @escaping (Bool, ErrorResponse?, String?) -> Void) {
        if let requestData = AuthenticationStore.shared.requestData {
            StudentDataStore.tryFetch(requestData: requestData) {
                success, data, errorResponse, error in
                if success, let data = data {
                    StudentDataStore.shared.save(studentData: data)
                }
                completion(success, errorResponse, error)
            }
        } else {
            completion(false, ErrorResponse(
                title: "Failed to refresh data",
                description: "No credential available, please try log in again."
            ), nil)
        }
    }
}

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

extension StudentDataStore {
    static func clearLocal() {
        Utils.saveStringToFile(filename: Constants.studentDataFileName, data: "")
    }
    
    static func tryLoadAndIfSuccess(callback: @escaping (StudentData) -> Void) {
        if let dataJsonString = Utils.readStringFromFile(filename: Constants.studentDataFileName) {
            do {
                let data = try StudentData(jsonString: dataJsonString)
                callback(data)
            } catch {
                print("Failed to serialize student data from file:" + " \(error)")
            }
        }
    }
    
    static func tryFetchAndIfSuccess(
        requestData: RequestData? = nil,
        callback: @escaping (StudentData) -> Void
    ) {
        tryFetch(requestData: requestData) { success, data, errorResponse, error in
            guard success else { return }
            if let data = data {
                callback(data)
            }
        }
    }
    
    static func tryFetch(
        requestData: RequestData? = AuthenticationStore.shared.requestData,
        completion: @escaping (Bool, StudentData?, ErrorResponse?, String?) -> Void
    ) {
        if let requestData = requestData ?? AuthenticationStore.shared.requestData {
            AF.request(
                Constants.getStudentDataURL,
                method: .post,
                parameters: requestData,
                encoder: JSONParameterEncoder.default
            )
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseString { response in
                    switch response.result {
                    case .success:
                        guard let jsonString = response.value else { return }
//                        debugPrint(jsonString)
                        debugPrint("JSON fetched")
                        do {
                            let data = try StudentData(jsonString: jsonString)
                            completion(true, data, nil, nil)
                        } catch {
                            do {
                                let errorResponse = try JSONDecoder()
                                    .decode(ErrorResponse.self, from: jsonString.data(using: .utf8)!)
                                if !errorResponse.hasErrorMessage {
                                    completion(
                                        false, nil, nil,
                                        error.localizedDescription +
                                        " Response:\n\(jsonString)"
                                    )
                                } else {
                                    completion(false, nil, errorResponse, nil)
                                }
                            } catch {
                                completion(
                                    false, nil, nil,
                                    error.localizedDescription +
                                    " Response:\n\(jsonString)"
                                )
                            }
                        }
                    case let .failure(error):
                        completion(false, nil, nil, error.localizedDescription)
                    }
                }
        }
    }
}
