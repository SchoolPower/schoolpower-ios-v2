//
//  WaveView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/24/21.
//

import SwiftUI

struct WaveView: View {
    var progressFraction: Double
    
    var body: some View {
        VStack {}
        .frame(maxWidth: 300, maxHeight: 300)
        .modifier(WaveViewModifier(progressFraction: progressFraction))
    }
}

fileprivate struct WaveViewModifier: AnimatableModifier {
    var progressFraction: Double
    
    var animatableData: CGFloat {
        get { progressFraction }
        set { progressFraction = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(WaveViewBase(progressFraction: progressFraction))
    }
}

fileprivate struct WaveViewBase: View, Animatable {
    @State private var waveOffset = Angle(degrees: 360)
    
    var progressFraction: Double
    
    var color: Color {
        progressFraction.fromPercentage().toLetterGrade().getLetterGradeColor()
    }
    
    var wave1: some View {
        Wave(
            offset: Angle(degrees: self.waveOffset.degrees),
            percentFraction: progressFraction
        )
            .fill(color.opacity(0.5))
            .clipShape(Circle())
    }
    
    var wave2: some View {
        Wave(
            offset: Angle(degrees: self.waveOffset.degrees - 180),
             percentFraction: progressFraction
        )
            .fill(color)
            .clipShape(Circle())
    }
    
    var text: some View {
        Text(String(format: "%.2f%%", progressFraction * 100.0))
            .font(.largeTitle)
            .bold()
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Circle()
                    .strokeBorder(color, lineWidth: 5)
                    .overlay(
                        ZStack {
                            text.foregroundColor(.black)
                            wave1
                            wave2
                            text.foregroundColor(.white).blendMode(.overlay)
                        }
                    )
                    .animation(
                        .linear(duration: 1).repeatForever(autoreverses: false),
                        value: waveOffset.degrees
                    )
            }
            .animation(.easeInOut)
            .aspectRatio(1, contentMode: .fit)
            .onAppear { self.waveOffset = Angle(degrees: 0) }
        }
    }
}

fileprivate struct Wave: Shape {
    var offset: Angle
    var percentFraction: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newPercent = lowfudge + (highfudge - lowfudge) * percentFraction
        let waveHeight = 0.015 * rect.height
        let yOffset = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = startAngle + Angle(degrees: 360)
        
        p.move(to: CGPoint(
            x: 0,
            y: yOffset + waveHeight * CGFloat(sin(offset.radians))
        ))
        
        for angle in stride(
            from: startAngle.degrees,
            through: endAngle.degrees,
            by: 5
        ) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(
                x: x,
                y: yOffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))
            ))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(progressFraction: 0.5)
    }
}
