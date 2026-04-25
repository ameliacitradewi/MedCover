//
//  HeightSelectorView.swift
//  MedCover
//

import SwiftUI
import Lottie

struct HeightView: View {
    @Binding var selectedHeightCm: Int
    
    // MARK: Config
    let minHeight: CGFloat = 50
    let maxHeight: CGFloat = 200
    let rulerHeight: CGFloat = 450
    
    @State private var heightCm: CGFloat = 160
    @State private var selectedGender: Gender = .female
    
    private let rulerWidth: CGFloat = 50
    private let dotSize: CGFloat = 12
    private let bubbleW: CGFloat = 68
    private let bubbleH: CGFloat = 52
    private let leftPad: CGFloat = 16
    private let tickCount: Int = 70
    
    // MARK: Lottie Scale (50cm -> 0.25 | 250cm -> 1.35)
    private var personScale: CGFloat {
        let progress = (heightCm - minHeight) / (maxHeight - minHeight)
        return 0.25 + progress * (1.2 - 0.25)
    }
    
    var body: some View {
        
        let lineY = min(
            max(yPosition(for: heightCm), bubbleH / 2),
            rulerHeight - bubbleH / 2
        )
        
        
        VStack(spacing: 30) {
            HStack(spacing: 14) {
                ToggleOptionButton(
                    title: Gender.female.title,
                    isSelected: selectedGender == .female
                ) {
                    selectedGender = .female
                }

                ToggleOptionButton(
                    title: Gender.male.title,
                    isSelected: selectedGender == .male
                ) {
                    selectedGender = .male
                }
            }
                .padding(.bottom, 10)
            
            ZStack(alignment: .bottomTrailing) {
                
                // =====================================================
                // LOTTIE CHARACTER
                // =====================================================
                LottieView(animation: .named(selectedGender == .female ? "female-passed.json" : "male-passed.json"))
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
                                            Color(
                                                red: 0.33,
                                                green: 0.58,
                                                blue: 0.97
                                            )
                                        )
                                )
                                .position(
                                    x: leftPad + bubbleW / 2,
                                    y: lineY
                                )
                        }
                    }
                    .frame(height: rulerHeight)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { val in
                                
                                let clamped = min(
                                    max(val.location.y, 0),
                                    rulerHeight
                                )
                                
                                heightCm = heightValue(for: clamped)
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
                                Color(
                                    red: 0.33,
                                    green: 0.58,
                                    blue: 0.97
                                )
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
    
    private func yPosition(for cm: CGFloat) -> CGFloat {
        let ratio = (maxHeight - cm) / (maxHeight - minHeight)
        return ratio * rulerHeight
    }
    
    private func heightValue(for y: CGFloat) -> CGFloat {
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

    var body: some View {
        HeightView(selectedHeightCm: $selectedHeightCm)
            .padding()
    }
}
