//
//  HeaderView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject private var authentication: AuthenticationStore
    @State private var viewState = HeaderViewState()
    
    var profile: Profile
    var extraInfo: ExtraInfo
    var body: some View {
        HStack(alignment: .center) {
            AvatarButton(profile: profile, extraInfo: extraInfo)
                .environmentObject(viewState)
            VStack(alignment: .leading) {
                Text(profile.fullName()).foregroundColor(.primary).font(.title2).bold()
                Spacer().frame(width: 2).fixedSize()
                Text(authentication.username ?? "").foregroundColor(.primary).font(.subheadline)
            }.padding(.leading)
        }
        .padding(.top)
        .padding(.bottom)
    }
}



struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(profile: fakeProfile(), extraInfo: fakeExtraInfo())
            .environmentObject(AuthenticationStore.shared)
    }
}
