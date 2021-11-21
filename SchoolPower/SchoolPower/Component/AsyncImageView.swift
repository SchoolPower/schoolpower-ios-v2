//
//  AsyncImageView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/20/21.
//

import Foundation
import SwiftUI

struct AsyncImageView: View {
    var imageURL: URL
    var forceFallbackImageView: Bool = false
    var contentMode: ContentMode = .fill
    var aspectRatio: CGFloat? = nil
    
    var body: some View {
        if #available(iOS 15.0, *), forceFallbackImageView != true {
            NewAsyncImageView(url: imageURL, contentMode: contentMode, aspectRatio: aspectRatio)
        } else {
            FallbackAsyncImageView(url: imageURL, contentMode: contentMode, aspectRatio: aspectRatio)
        }
    }
}

@available(iOS 15.0, *)
fileprivate struct NewAsyncImageView: View {
    var url: URL
    var contentMode: ContentMode
    var aspectRatio: CGFloat? = nil
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable().aspectRatio(aspectRatio, contentMode: contentMode)
        } placeholder: {
            ProgressView()
        }
    }
}

fileprivate struct FallbackAsyncImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()
    private var contentMode: ContentMode
    private var aspectRatio: CGFloat? = nil

    init(url: URL, contentMode: ContentMode, aspectRatio: CGFloat?) {
        imageLoader = ImageLoader(url: url)
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(aspectRatio, contentMode: contentMode)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
