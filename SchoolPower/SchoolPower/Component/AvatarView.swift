//
//  AvatarView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import SwiftUI

private struct TextAvatarView: View {
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

@available(iOS 15.0, *)
private struct AsyncImageAvatarView: View {
    var url: URL
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 64, height: 64)
        .cornerRadius(32)
    }
}

private struct AsyncImageAvatarViewFallback: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()

    init(url: URL) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 64, height: 64)
            .cornerRadius(32)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

struct AvatarView: View {
    var text: String
    var imageURL: String?
    var isLoading: Bool?
    
    var forceFallbackImageView: Bool?
    
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
            if #available(iOS 15.0, *), forceFallbackImageView != true {
                AsyncImageAvatarView(url: url)
            } else {
                AsyncImageAvatarViewFallback(url: url)
            }
        } else {
            TextAvatarView(text: text)
        }
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
