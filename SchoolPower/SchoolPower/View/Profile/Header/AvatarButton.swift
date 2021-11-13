//
//  AvatarButton.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct AvatarButton: View {
    var profile: Profile
    var extraInfo: ExtraInfo
    
    @EnvironmentObject private var viewState: HeaderViewState
    @State private var showingAvatarAgreement = false
    @State private var showingAvatarUploadSelect = false
    @State private var showingAvatarActionSelect = false
    @State private var showingActionSheet: Sheets? = nil
    
    enum Sheets: Identifiable {
        case uploadOptions, changeOrRemove
        
        var id: Int {
            self.hashValue
        }
    }
    
    private func showAvatarAgreement() {
        showingAvatarAgreement = true
    }
    
    private func showAvatarUploadSelect() {
        showingActionSheet = .uploadOptions
    }
    
    private func showAvatarActionSelect() {
        showingActionSheet = .changeOrRemove
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
                text: profile.lastName.first?.uppercased() ?? String(profile.id).first?.uppercased() ?? "",
                imageURL: extraInfo.avatarURL
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var body: some View {
        avatarButton
            .alert(isPresented: $showingAvatarAgreement) {
                Alert(
                    title: Text("Image Upload Agreement"),
                    message: Text("agreement"),
                    primaryButton: .default(Text("Accept")) {
                        showAvatarUploadSelect()
                    },
                    secondaryButton: .cancel(Text("Decline"))
                )
            }
            .actionSheet(item: $showingActionSheet) { item in
                switch item {
                case .uploadOptions:
                    return ActionSheet(
                        title: Text("Choose how to upload"),
                        buttons: [
                            .cancel() { showingActionSheet = nil },
                            .default(Text("Take photo")) {
                                viewState.takePhoto()
                            },
                            .default(Text("Choose from album")) {
                                viewState.chooseFromAlbum()
                            },
                        ]
                    )
                case .changeOrRemove:
                    return ActionSheet(
                        title: Text("Choose an action"),
                        buttons: [
                            .cancel() { showingActionSheet = nil },
                            .default(Text("Change avatar")) {
                                showAvatarUploadSelect()
                            },
                            .destructive(Text("Remove avatar")) {
                                viewState.removeAvatar()
                            },
                        ]
                    )
                }
            }
    }
}

struct AvatarButton_Previews: PreviewProvider {
    static var previews: some View {
        AvatarButton(profile: fakeProfile(), extraInfo: fakeExtraInfo())
    }
}
