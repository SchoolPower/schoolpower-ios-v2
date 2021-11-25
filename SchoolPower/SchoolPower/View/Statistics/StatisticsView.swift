//
//  StatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/24/21.
//

import SwiftUI

struct StatisticsView: View {
    @State var progressValue: Double = 0.97
    var body: some View {
        ZStack {
            VStack {
                WaveView(progressFraction: self.progressValue)
                Spacer()
                Button(action: {
                    self.incrementProgress()
                }) {
                    HStack {
                        Image(systemName: "wand.and.rays")
                    }
                    .padding(15.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(lineWidth: 2.0)
                    )
                }
            }
        }
    }
    
    func incrementProgress() {
        let randomValue = Double.random(in: 0..<1)
        withAnimation(.easeInOut(duration: 0.75)) {
            self.progressValue = randomValue
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}

