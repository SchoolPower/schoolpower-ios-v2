//
//  ExtraInfo.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import Foundation

func fakeExtraInfo() -> ExtraInfo {
    var extraInfo = ExtraInfo()
    extraInfo.avatarURL = "https://i.ytimg.com/vi/9QLT1Aw_45s/maxresdefault.jpg"
    extraInfo.informationCard = fakeInformationCard()
    return extraInfo
}
