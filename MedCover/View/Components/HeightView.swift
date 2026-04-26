//
//  HeightSelectorView.swift
//  MedCover
//

import SwiftUI
import Lottie

struct HeightView: View {
    @Binding var selectedHeightCm: Int
    @Binding var selectedGender: Gender
    
    // MARK: Config
    let minHeight: CGFloat = 50
    let maxHeight: CGFloat = 200
    let maxRulerHeight: CGFloat = 450
    
    @State private var heightCm: CGFloat = 160
    private let rulerWidth: CGFloat = 50
    private let dotSize: CGFloat = 12
    private let bubbleW: CGFloat = 68
    private let bubbleH: CGFloat = 52
    private let leftPad: CGFloat = 16
    private let tickCount: Int = 70
    
    // MARK: Lottie Scale (50cm -> 0.25 | 250cm -> 1.35)
    private var personScale: CGFloat {
        let progress = (heightCm - minHeight) / (maxHeight - minHeight)
        return 0.25 + progress * (1.0 - 0.25)
    }
    
    var body: some View {
        GeometryReader { geo in
            let rulerHeight = min(maxRulerHeight, geo.size.height)
            let lineY = min(
                max(yPosition(for: heightCm, rulerHeight: rulerHeight), bubbleH / 2),
                rulerHeight - bubbleH / 2
            )
            
            ZStack(alignment: .center) {
                
                // =====================================================
                // LOTTIE CHARACTER
                // =====================================================
                LottieView(animation: .named(selectedGender == .female ? "Female.json" : "Male.json"))
                    .playing(loopMode: .loop)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: rulerHeight, alignment: .bottom)
                    .scaleEffect(personScale, anchor: .bottom)
                    .clipped()
                
                // =====================================================
                // MAIN UI
                // =====================================================
                HStack(alignment: .top, spacing: 0) {
                    
                    // MARK: Left Area
                    GeometryReader { geo in
                        let w = geo.size.width
                        
                        ZStack {
                            Color.clear
                                .frame(width: w, height: rulerHeight)
                            
                            // horizontal line
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(
                                    width: w - leftPad - bubbleW,
                                    height: 1
                                )
                                .position(
                                    x: leftPad + bubbleW + (w - leftPad - bubbleW) / 2,
                                    y: lineY
                                )
                            
                            // blue bubble
                            Text("\(Int(heightCm))\ncm")
                                .font(.system(size: 17, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: bubbleW, height: bubbleH)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: "C21014"), Color(hex: "880606")],
                                                startPoint: .top,
                                                endPoint: .bottom)
                                        )
                                )
                                .position(
                                    x: leftPad + bubbleW / 2,
                                    y: lineY
                                )
                        }
                    }
                    .frame(maxHeight: rulerHeight)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { val in
                                
                                let clamped = min(
                                    max(val.location.y, 0),
                                    rulerHeight
                                )
                                
                                heightCm = heightValue(for: clamped, rulerHeight: rulerHeight)
                            }
                    )
                    
                    // MARK: Right Ruler
                    ZStack(alignment: .topLeading) {
                        Canvas { ctx, size in
                            
                            for i in 0...tickCount {
                                
                                let y = CGFloat(i) / CGFloat(tickCount) * size.height
                                let tickW: CGFloat = i % 5 == 0 ? 26 : 13
                                
                                var path = Path()
                                path.move(
                                    to: CGPoint(
                                        x: size.width - tickW,
                                        y: y
                                    )
                                )
                                
                                path.addLine(
                                    to: CGPoint(
                                        x: size.width,
                                        y: y
                                    )
                                )
                                
                                ctx.stroke(
                                    path,
                                    with: .color(Color.black.opacity(1)),
                                    lineWidth: 1.5
                                )
                            }
                        }
                        .frame(
                            width: rulerWidth,
                            height: rulerHeight
                        )
                        
                        Circle()
                            .fill(
                                Color(hex: "880606")
                            )
                            .frame(
                                width: dotSize,
                                height: dotSize
                            )
                            .offset(
                                x: -(dotSize / 2 + 1),
                                y: lineY - dotSize / 2
                            )
                    }
                    .frame(
                        width: rulerWidth,
                        height: rulerHeight
                    )
                }
            }
            .frame(height: rulerHeight)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .animation(
                .interactiveSpring(
                    response: 0.3,
                    dampingFraction: 0.75
                ),
                value: heightCm
            )
        }
        .onAppear {
            let initial = CGFloat(selectedHeightCm)
            heightCm = min(max(initial, minHeight), maxHeight)
        }
        .onChange(of: heightCm) {_, newValue in
            selectedHeightCm = Int(newValue.rounded())
        }
    }
    
    // MARK: Helpers
    
    private func yPosition(for cm: CGFloat, rulerHeight: CGFloat) -> CGFloat {
        let ratio = (maxHeight - cm) / (maxHeight - minHeight)
        return ratio * rulerHeight
    }
    
    private func heightValue(for y: CGFloat, rulerHeight: CGFloat) -> CGFloat {
        let ratio = y / rulerHeight
        let value = maxHeight - ratio * (maxHeight - minHeight)
        return min(max(value, minHeight), maxHeight)
    }
}

#Preview {
    HeightPreview()
}

private struct HeightPreview: View {
    @State private var selectedHeightCm: Int = 160
    @State private var selectedGender: Gender = .female

    var body: some View {
        HeightView(
            selectedHeightCm: $selectedHeightCm,
            selectedGender: $selectedGender
        )
            .padding()
    }
}
