//
//  WaveView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/24/21.
//

import SwiftUI

struct WaveView: View {
    // in 0..<1
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

// Credit: https://stackoverflow.com/a/63412977
fileprivate struct WaveViewBase: View {
    @State private var waveOffset = Angle(degrees: 360)
    
    var progressFraction: Double
    
    private var color: Color {
        progressFraction.fromPercentage().toLetterGrade().getLetterGradeColor()
    }
    
    private var waveBack: some View {
        Wave(
            offset: Angle(degrees: waveOffset.degrees + 180),
            percentFraction: progressFraction
        )
            .fill(color.opacity(0.5))
            .clipShape(Circle())
    }
    
    private var waveFront: some View {
        Wave(
            offset: Angle(degrees: waveOffset.degrees),
            percentFraction: progressFraction
        )
            .fill(color)
            .clipShape(Circle())
    }
    
    private var text: some View {
        Text(String(format: "%.2f%%", progressFraction * 100.0))
            .font(.largeTitle)
            .bold()
    }
    
    var body: some View {
        Circle()
            .strokeBorder(color, lineWidth: 5)
            .overlay(
                ZStack {
                    text.foregroundColor(.black)
                    waveBack
                    waveFront
                    text.foregroundColor(.white).blendMode(.overlay)
                }
            )
            .animation(
                .linear(duration: 1).repeatForever(autoreverses: false),
                value: waveOffset.degrees
            )
            .animation(.easeInOut)
            .onAppear { waveOffset = Angle(degrees: 0) }
    }
}

// Credit: https://stackoverflow.com/a/63412977
fileprivate struct Wave: Shape {
    var offset: Angle
    var percentFraction: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startAngle = offset
        let endAngle = startAngle + Angle(degrees: 360)
        
        let amplitude = 0.015 * rect.height
        let disturbedPercentFraction = 0.02 + 0.96 * percentFraction
        
        let offsetY = CGFloat(1 - disturbedPercentFraction) * rect.height
        let startY = offsetY + amplitude * CGFloat(sin(offset.radians))
        
        path.move(to: CGPoint(x: 0, y: startY))
        
        for angle in stride(
            from: startAngle.degrees,
            through: endAngle.degrees,
            by: 5
        ) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            let y = offsetY + amplitude * CGFloat(sin(Angle(degrees: angle).radians))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(progressFraction: 0.5)
    }
}
