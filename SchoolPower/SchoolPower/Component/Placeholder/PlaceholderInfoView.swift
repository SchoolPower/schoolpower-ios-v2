//
//  PlaceholderInfoView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct PlaceholderInfoView: View {
    var title: String?
    var message: String?
    var image: Image
    var opacity: CGFloat?
    
    private func idealSize(geometry: GeometryProxy) -> CGFloat {
        let bound = min(geometry.size.width, geometry.size.height)
        return bound * 0.5
    }
        
    var body: some View {
        GeometryReader() { geometry in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    image
                        .resizable()
                        .opacity(opacity ?? 1)
                        .frame(
                            width: idealSize(geometry: geometry),
                            height: idealSize(geometry: geometry)
                        )
                    if let title = title {
                        Text(LocalizedStringKey(title)).multilineTextAlignment(.center).padding(.top, 16).opacity(0.5)
                    }
                    if let message = message {
                        Text(LocalizedStringKey(message)).font(.caption).multilineTextAlignment(.center).padding(.top, 1).opacity(0.5)
                    }
                    Spacer()
                }
                .frame(maxWidth: idealSize(geometry: geometry))
                Spacer()
            }
        }
    }
}

struct PlaceholderInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderInfoView(
            title: "PS Turned Off aaa as Lorem ipsum dolar sit amet", message: "Lorem ipsum dolar sit amet", image: Image("no_grades")
        )
    }
}
