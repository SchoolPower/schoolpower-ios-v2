//
//  HeaderViewState.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import Foundation
import UIKit
import Alamofire

class HeaderViewState: ObservableObject {
    @Published var isLoadingAvatar: Bool = false
    @Published var selectedImage: UIImage?
    @Published var croppedImage: UIImage?
    
    // Uploads image to sm.ms
    func uploadAvatar(completion: @escaping (Bool, ErrorResponse?, String?) -> Void) {
        guard let croppedImage = croppedImage else {
            completion(false, ErrorResponse(title: "Failed to upload avatar".localized, description: "No image selected.".localized), nil)
            return
        }
        guard let data = croppedImage.jpegData(compressionQuality: 0.5) else {
            completion(false, ErrorResponse(title: "Failed to upload avatar".localized, description: "Cannot get image JPEG data.".localized), nil)
            return
        }
        self.selectedImage = nil
        self.croppedImage = nil
        isLoadingAvatar = true
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "smfile", fileName: "avatar.png", mimeType: "image/png")
            },
            to: Constants.imageUploadURL,
            headers: HTTPHeaders([HTTPHeader(name: "Authorization", value: "Y18dxYUfOL1jIpiQe81SAwv3x34T4ANy")])
        )
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    guard let jsonString = response.value else { return }
                    debugPrint("Image uploaded")
                    do {
                        let responseJson = try JSONDecoder().decode(ImageUploadResponse.self, from: jsonString.data(using: .utf8)!)
                        if responseJson.code == "image_repeated", let url = responseJson.images {
                            self.updateAvatarURL(url: url, hash: "", completion: completion)
                        } else {
                            self.updateAvatarURL(url: responseJson.data!.url, hash: responseJson.data!.hash, completion: completion)
                        }
                    } catch {
                        completion(
                            false,
                            ErrorResponse(
                                title: "Failed to upload avatar".localized,
                                description: "Responce:\n\(jsonString)".localized
                            ),
                            nil
                        )
                    }
                case let .failure(error):
                    completion(false, nil, error.localizedDescription)
                }
            }
    }
    
    // Update URL to BE, then fetch new student data
    private func updateAvatarURL(
        url: String,
        hash: String,
        completion: @escaping (Bool, ErrorResponse?, String?) -> Void
    ) {
        guard let requestData = AuthenticationStore.shared.requestData else {
            completion(false, nil, "No credential available, please try to log in again.")
            return
        }
        
        AF.request(
            Constants.setAvatarURL,
            method: .post,
            parameters: SetAvatarResponse(
                username: requestData.username,
                password: requestData.password,
                new_avatar: url,
                remove_code: hash
            ),
            encoder: JSONParameterEncoder.default
        )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString { response in
                switch response.result {
                case .success:
                    guard let jsonString = response.value else { return }
                    debugPrint("Image URL updateded")
                    do {
                        let errorResponse = try JSONDecoder()
                            .decode(ErrorResponse.self, from: jsonString.data(using: .utf8)!)
                        if errorResponse.success == true {
                            StudentDataStore.tryFetch(action: .getAvatar) {
                                success, data, errorResponse, error in
                                
                                if success, let data = data {
                                    StudentDataStore.shared.save(studentData: data)
                                }
                                
                                completion(true, errorResponse, error)
                            }
                        } else {
                            completion(false, errorResponse, nil)
                        }
                    } catch {
                        completion(
                            false,
                            nil,
                            error.localizedDescription +
                            " Response:\n\(jsonString)"
                        )
                    }
                case let .failure(error):
                    completion(false, nil, error.localizedDescription)
                }
            }
    }
    
    func removeAvatar(completion: @escaping (Bool, ErrorResponse?, String?) -> Void) {
        updateAvatarURL(url: "", hash: "", completion: completion)
    }
}
