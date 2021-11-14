//
//  SettingItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct SettingItem: View {
    var title: LocalizedStringKey
    var detail: String? = nil
    var image: String? = nil
    var description: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let image = image {
                    Label(title, systemImage: image)
                } else {
                    Text(title)
                }
                if let description = description {
                    Text(LocalizedStringKey(description)).foregroundColor(.gray).font(.caption)
                }
            }
            Spacer()
            if let detail = detail {
                Text(LocalizedStringKey(detail)).foregroundColor(.gray)
            }
        }
    }
}
