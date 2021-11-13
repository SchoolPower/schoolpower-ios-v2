//
//  LoginViewModel.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var loginData: RequestData = RequestData()
    @Published var isLoading: Bool = false
    
    func login(completion: @escaping (Bool, RequestData, ErrorResponse?, String?) -> Void) {
        let requestData = loginData
        isLoading = true
        StudentDataStore.tryFetch(requestData: requestData) {
            [unowned self] success, data, errorResponse, error in

            isLoading = false

            if success, let data = data {
                StudentDataStore.shared.save(studentData: data)
            }

            completion(success, requestData, errorResponse, error)
        }
    }
}
