//
//  AvatarButton.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI
import Introspect

struct AvatarButton: View {
    var profile: Profile
    var extraInfo: ExtraInfo
    
    @EnvironmentObject private var viewState: HeaderViewState
    @State private var showingAvatarAgreement = false
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var showingImageCropper = false
    
    @State private var errorResponse: ErrorResponse? = nil
    @State private var showingError: Bool = false
    
    private func showAvatarAgreement() {
        showingAvatarAgreement = true
    }
    
    private func showAvatarActionSelect() {
        showingActionSheet = true
    }
    
    private func showImagePicker() {
        showingImagePicker = true
    }
    
    private func showImageCropper() {
        guard viewState.selectedImage != nil else { return }
        showingImageCropper = true
    }
    
    private func avatarOnClick() {
        if extraInfo.avatarURL.isEmpty {
            showAvatarAgreement()
        } else {
            showAvatarActionSelect()
        }
    }
    
    private var avatarButton: some View {
        Button(action: {
            avatarOnClick()
        }) {
            AvatarView(
                text: profile.lastName.first?.uppercased()
                ?? String(profile.id).first?.uppercased()
                ?? "",
                imageURL: extraInfo.avatarURL,
                isLoading: viewState.isLoadingAvatar
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func uploadAvatar() {
        guard viewState.croppedImage != nil else {
            return
        }
        viewState.uploadAvatar { success, errorResponse, error in
            viewState.isLoadingAvatar = false
            if !success {
                self.errorResponse = errorResponse
                ?? ErrorResponse(
                    title: "Failed to upload avatar",
                    description: error ?? "Unknown error."
                )
                showingError = true
            }
        }
    }
    
    var body: some View {
        avatarButton
            .alert(isPresented: $showingAvatarAgreement) {
                Alert(
                    title: Text("Image Upload Agreement"),
                    message: Text("image_upload_agreement_content"),
                    primaryButton: .default(Text("Accept")) {
                        showImagePicker()
                    },
                    secondaryButton: .cancel(Text("Decline"))
                )
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Choose an action"),
                    buttons: [
                        .cancel(),
                        .default(Text("Change avatar")) {
                            showImagePicker()
                        },
                        .destructive(Text("Remove avatar")) {
                            viewState.isLoadingAvatar = true
                            viewState.removeAvatar { success, errorResponse, error in
                                viewState.isLoadingAvatar = false
                                if !success {
                                    self.errorResponse = errorResponse
                                    ?? ErrorResponse(
                                        title: "Failed to remove avatar",
                                        description: error ?? "Unknown error."
                                    )
                                    showingError = true
                                }
                            }
                        },
                    ]
                )
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: showImageCropper) {
                ImagePicker(image: $viewState.selectedImage)
            }
            .sheet(isPresented: $showingImageCropper, onDismiss: uploadAvatar) {
                ImageCropper(
                    image: $viewState.selectedImage,
                    croppedImage: $viewState.croppedImage
                )
            }
        AlertIfError(showingAlert: $showingError, errorResponse: $errorResponse)
    }
}

struct AvatarButton_Previews: PreviewProvider {
    static var previews: some View {
        AvatarButton(profile: fakeProfile(), extraInfo: fakeExtraInfo())
            .environmentObject(HeaderViewState())
    }
}
