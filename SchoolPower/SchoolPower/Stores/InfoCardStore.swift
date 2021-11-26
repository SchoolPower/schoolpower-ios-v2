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
    
    private var infoCardReceived: InfoCardContent? = nil
    
    @Published var infoCardToShow: InfoCardContent? = nil
    
    var shouldShowInfoCard: Bool {
        infoCardToShow != nil
    }
    
    init() {
        loadInfoCard()
    }
    
    func maybeShowInfoCard() {
        if let infoCardReceived = infoCardReceived {
            guard infoCardReceived.activated == true else {
                return
            }
            let dismissedBefore = SettingsStore.shared.dismissedInfoCardUUIDs[infoCardReceived.uuid]
            guard dismissedBefore == nil else {
                return
            }
            infoCardToShow = infoCardReceived
        }
    }
    
    func loadInfoCard() {
        // TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.infoCardReceived = fakeInfoCardContent()
            self.maybeShowInfoCard()
        }
    }
    
    func dismiss() {
        if let infoCardToShow = infoCardToShow {
            var temp = SettingsStore.shared.dismissedInfoCardUUIDs
            temp[infoCardToShow.uuid] = true
            SettingsStore.shared.dismissedInfoCardUUIDs = temp
            self.infoCardToShow = nil
        }
    }
}
