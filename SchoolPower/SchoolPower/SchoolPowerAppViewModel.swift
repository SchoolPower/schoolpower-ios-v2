//
//  SchoolPowerAppViewModel.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/5/21.
//

import Foundation
import Alamofire
import SwiftProtobuf

class SchoolPowerAppViewModel: ObservableObject {
    let url = "https://api-fc.schoolpower.tech/v3/get_data"

    @Published var studentData: StudentData = StudentData()

    init() {
        fetchStudentData()
    }

    func fetchStudentData() {
        AF.request(
            url,
            method: .post,
            parameters: RequestData(
                username: "2019030077",
                password: "ryh004324"
            ),
            encoder: JSONParameterEncoder.default
        )
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseString { response in
            switch response.result {
            case .success:
                guard let jsonString = response.value else { return }
                debugPrint(jsonString)
                do {
                    let data = try StudentData(jsonString: jsonString)
                    self.studentData = data
                } catch let e {
                    print(e)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
