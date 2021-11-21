//
//  AvatarView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import SwiftUI

struct AvatarView: View {
    var text: String
    var imageURL: String?
    var isLoading: Bool?
    
    var forceFallbackImageView: Bool = false
    
    private var url: URL? {
        if let imageURL = imageURL {
            return URL(string: imageURL)
        } else {
            return nil
        }
    }
    
    var body: some View {
        if isLoading == true {
            ProgressView()
                .frame(width: 64, height: 64)
                .cornerRadius(32)
        } else if let url = url {
            AsyncImageView(imageURL: url, forceFallbackImageView: forceFallbackImageView)
                .frame(width: 64, height: 64)
                .cornerRadius(32)
        } else {
            TextAvatarView(text: text)
        }
    }
}

fileprivate struct TextAvatarView: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(width: 64, height: 64)
            .foregroundColor(.white)
            .font(.title3)
            .background(
                Circle()
                    .foregroundColor(.purple)
            )
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AvatarView(text: "S")
            AvatarView(text: "S", imageURL: "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg")
            AvatarView(text: "S", imageURL: "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg", isLoading: true)
            AvatarView(text: "S", imageURL: "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg", forceFallbackImageView: true)
            AvatarView(text: "S", imageURL: "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg", isLoading: true, forceFallbackImageView: true)
        }
    }
}
