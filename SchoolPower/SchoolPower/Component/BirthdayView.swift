//
//  BirthdayView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/28/21.
//

import SwiftUI

struct BirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var studentDataStore: StudentDataStore
    @State var loaded = false
    
    private func idealSize(_ geo: GeometryProxy) -> CGFloat {
        return min(500, min(geo.size.width, geo.size.height) * 0.6)
    }
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                VStack {
                    Text("App.HappyBirthday.Title".localized(
                        // Birthday with age requires ordinal in some languages
                        // (e.g. 18th birthday)
                        // and not in others
                        // (e.g. 18岁生日, instead of 第18岁生日)
                        // we'll pass in both and the localized string can choose
                        // to use either (by optionally applying markup
                        // to ignore the first)
                        studentDataStore.getAge().ordinal(),
                        studentDataStore.getAge().toString()
                    ).deletedWithMarkup())
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    if loaded {
                        LottieView(name: "gift_box")
                            .frame(
                                width: idealSize(geo),
                                height: idealSize(geo)
                            )
                    } else {
                        VStack {}
                        .frame(
                            width: idealSize(geo),
                            height: idealSize(geo)
                        )
                    }
                    Text("App.HappyBirthday.Message")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .padding(.bottom, 32)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    loaded = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("App.HappyBirthday.Thanks")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayView()
    }
}
