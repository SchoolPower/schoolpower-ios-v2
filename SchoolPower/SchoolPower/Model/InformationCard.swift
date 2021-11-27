//
//  InformationCard.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/15/21.
//

import Foundation

func fakeInformationCard() -> InformationCard {
    var info = InformationCard()
    info.identifier = "11"
    info.title = "フォニー"
    info.message = """
        この世で造花より綺麗な花は無いわ
        何故ならば総ては嘘で出来ている
        antipathy world

        絶望の雨はあたしの傘を突いて
        湿らす前髪とこころの裏面
        煩わしいわ
        """
    info.primaryText = "プレイ"
    info.primaryOnClickURL = "https://www.youtube.com/watch?v=9QLT1Aw_45s"
    info.imageURL = "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg"
    info.titleBackgroundColorHex = "#C3B9A9"
    info.messageBackgroundColorHex = "#AE9F90"
    info.isActive = true
    return info
}
