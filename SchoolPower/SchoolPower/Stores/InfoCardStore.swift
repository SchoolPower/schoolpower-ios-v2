//
//  InfoCardStore.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/15/21.
//

import Foundation
import SwiftUI

class InfoCardStore: ObservableObject {
    static let shared = InfoCardStore()
    
    @Published var infoCardToShow: InfoCardContent? = nil
    
    var shouldShowInfoCard: Bool {
        infoCardToShow != nil
    }
    
    init() {
        loadInfoCard()
    }
    
    func loadInfoCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("[[][[]")
            self.infoCardToShow = InfoCardContent(uuid: "1", localizedTitle: "カーニバルハッピー", localizedDescription:
                                                    """
この世で造花より綺麗な花は無いわ
何故ならば総ては嘘で出来ている
antipathy world
 
絶望の雨はあたしの傘を突いて
湿らす前髪とこころの裏面
煩わしいわ
 
何時しか言の葉は疾うに枯れきって
事の実があたしに熟れている
鏡に映り嘘を描いて自らを見失なった絵画
""", localizedCTAText: "ホロ", imageURL: "", debugging: true)
        }
    }
    
    func dismiss() {
        infoCardToShow = nil
    }
}
