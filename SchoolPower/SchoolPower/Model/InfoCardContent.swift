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
    var localizedCtaText: String
    var ctaURL: String
    var imageURL: String
    var colorHex: String
    var colorDarkHex: String
    var activated: Bool
}

func fakeInfoCardContent() -> InfoCardContent {
    return InfoCardContent(
        uuid: "9",
        localizedTitle: "フォニー",
        localizedDescription: """
            この世で造花より綺麗な花は無いわ
            何故ならば総ては嘘で出来ている
            antipathy world

            絶望の雨はあたしの傘を突いて
            湿らす前髪とこころの裏面
            煩わしいわ
            """,
        localizedCtaText: "プレイ",
        ctaURL: "https://www.youtube.com/watch?v=9QLT1Aw_45s",
        imageURL: "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg",
        colorHex: "#C3B9A9",
        colorDarkHex: "#AE9F90",
        activated: true
    )
}
