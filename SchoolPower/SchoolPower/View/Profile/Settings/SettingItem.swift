//
//  SettingItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct SettingItem: View {
    var title: String
    var detail: String? = nil
    var image: String? = nil
    var description: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if image != nil {
                    Label(title, systemImage: image!)
                } else {
                    Text(title)
                }
                if description != nil {
                    Text(description!).foregroundColor(.gray).font(.caption)
                }
            }
            Spacer()
            if detail != nil {
                Text(detail!).foregroundColor(.gray)
            }
        }
    }
}
