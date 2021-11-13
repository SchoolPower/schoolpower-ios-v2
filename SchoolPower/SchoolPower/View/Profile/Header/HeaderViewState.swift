//
//  HeaderViewState.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import Foundation

class HeaderViewState: ObservableObject {
    @Published var isLoadingAvatar: Bool = false
    
    func takePhoto() {
        
        uploadAvatar()
    }
    
    func chooseFromAlbum() {
        
        uploadAvatar()
    }
    
    func uploadAvatar() {
        
    }
    
    func removeAvatar() {
        
    }
}
