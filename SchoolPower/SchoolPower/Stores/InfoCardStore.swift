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
    
    private var infoCardReceived: InformationCard? = nil
    
    @Published var infoCardToShow: InformationCard? = nil
    
    var shouldShowInfoCard: Bool {
        infoCardToShow != nil
    }
    
    func maybeShowInfoCard() {
        if let infoCardReceived = infoCardReceived {
            guard infoCardReceived.isActive == true else {
                return
            }
            let dismissedBefore = SettingsStore.shared.dismissedInfoCardUUIDs[infoCardReceived.identifier]
            guard dismissedBefore == nil else {
                return
            }
            infoCardToShow = infoCardReceived
        }
    }
    
    func load(_ informationCard: InformationCard) {
        self.infoCardReceived = informationCard
        self.maybeShowInfoCard()
    }
    
    func dismiss() {
        if let infoCardToShow = infoCardToShow {
            var temp = SettingsStore.shared.dismissedInfoCardUUIDs
            temp[infoCardToShow.identifier] = true
            SettingsStore.shared.dismissedInfoCardUUIDs = temp
            self.infoCardToShow = nil
        }
    }
}
