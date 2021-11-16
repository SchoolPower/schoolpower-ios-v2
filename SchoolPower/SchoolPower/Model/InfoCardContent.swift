//
//  InfoCardContent.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/15/21.
//

import Foundation

struct InfoCardContent {
    var uuid: String
    var localizedTitle: String
    var localizedDescription: String
    var localizedCTAText: String
    var imageURL: String
    var debugging: Bool
}

func fakeInfoCardContent() -> InfoCardContent {
    return InfoCardContent(uuid: "1", localizedTitle: "Title", localizedDescription: "Description", localizedCTAText: "CTA", imageURL: "", debugging: true)
}

func fakeLongInfoCardContent() -> InfoCardContent {
    return InfoCardContent(uuid: "1", localizedTitle: "Title", localizedDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vel ante id sapien auctor cursus. Sed vel magna eget justo semper maximus a vitae dolor. Pellentesque fringilla sapien ornare metus lobortis, at vehicula libero interdum. Curabitur orci purus, egestas quis ex a, dignissim maximus erat. Quisque placerat elementum lacus, id tempus sapien venenatis quis. Vestibulum erat tortor, facilisis vel sollicitudin a, cursus eu turpis. Mauris vitae nisl ut nisl blandit fermentum id vel eros. In lobortis purus orci, in viverra ex ornare at. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed ut fringilla felis. Nulla facilisi. Maecenas at purus in enim efficitur sodales vitae at sapien. Duis rutrum varius purus, eu semper felis rutrum quis. Morbi urna est, suscipit eu neque ac, dictum pulvinar sem.", localizedCTAText: "CTA", imageURL: "", debugging: true)
}
