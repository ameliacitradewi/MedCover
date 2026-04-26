import SwiftUI
import UIKit

struct WeightPickerView: View {
    @Binding var selectedWeight: Int
    @StateObject private var viewModel = WeightPickerViewModel()
    @State private var lastHapticWeight: Int?
    private let selectionFeedback = UISelectionFeedbackGenerator()

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("\(viewModel.currentWeight)")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(hex: "1A202C"))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: viewModel.currentWeight)

                Text("kg")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "C0C8D8"))
            }

            Image(systemName: "arrowtriangle.down.fill")
                .foregroundColor(Color(hex: "4CAF50"))

            InfiniteDialView(viewModel: viewModel)
                .frame(height: 190)
        }
        .padding()
        .onAppear {
            viewModel.syncFromSelectedWeight(selectedWeight)
            lastHapticWeight = viewModel.currentWeight
            selectionFeedback.prepare()
        }
        .onChange(of: viewModel.currentWeight) { _, newValue in
            if lastHapticWeight != newValue {
                selectionFeedback.selectionChanged()
                selectionFeedback.prepare()
                lastHapticWeight = newValue
            }
            selectedWeight = newValue
        }
        .onChange(of: selectedWeight) { _, newValue in
            if newValue != viewModel.currentWeight {
                viewModel.syncFromSelectedWeight(newValue)
            }
        }
    }
}

struct InfiniteDialView: View {
    @ObservedObject var viewModel: WeightPickerViewModel

    private func wrappedDisplayKg(for index: Int) -> Int {
        let cycle = viewModel.maxKg
        guard cycle > 0 else { return 0 }
        var value = index % cycle
        if value <= 0 { value += cycle }
        return value
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let radius: CGFloat = width / 2.05
            let cx = width / 2
            let cy = height

            ZStack {
                SemicircleShape()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "FDDDE6"), Color(hex: "F9B0C4")],
                            center: .init(x: 0.5, y: 1.0),
                            startRadius: 20,
                            endRadius: radius
                        )
                    )
                    .shadow(color: Color.black.opacity(0.10), radius: 20, x: 0, y: -8)

                ticksLayer(radius: radius, cx: cx, cy: cy, width: width, height: height)
                    .clipShape(SemicircleShape())

                labelsLayer(radius: radius, cx: cx, cy: cy, width: width, height: height)

                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { val in
                                withAnimation(.interactiveSpring(response: 0.12, dampingFraction: 0.9)) {
                                    viewModel.handleDragChanged(
                                        translationWidth: val.translation.width,
                                        radius: radius
                                    )
                                }
                            }
                            .onEnded { val in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                    viewModel.handleDragEnded(
                                        translationWidth: val.translation.width,
                                        radius: radius
                                    )
                                }
                            }
                    )
            }
        }
    }

    @ViewBuilder
    private func ticksLayer(radius: CGFloat, cx: CGFloat, cy: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        Canvas { ctx, _ in
            ctx.translateBy(x: cx, y: cy)
            let minI = Int(floor((viewModel.rawAngle - 90) / viewModel.degreesPerKg)) - 60
            let maxI = Int(ceil((viewModel.rawAngle + 90) / viewModel.degreesPerKg)) + 60

            for i in minI...maxI {
                let displayKg = wrappedDisplayKg(for: i)
                let isMajor = displayKg % 5 == 0
                let angleDeg = Double(i) * viewModel.degreesPerKg - viewModel.rawAngle - 90.0
                let angleRad = angleDeg * .pi / 180.0

                let outerR = radius - 5
                let tickLen: CGFloat = isMajor ? 24 : 13
                let lineW: CGFloat = isMajor ? 2.4 : 1.2

                var path = Path()
                path.move(to: CGPoint(x: outerR * CGFloat(cos(angleRad)), y: outerR * CGFloat(sin(angleRad))))
                path.addLine(to: CGPoint(x: (outerR - tickLen) * CGFloat(cos(angleRad)), y: (outerR - tickLen) * CGFloat(sin(angleRad))))

                ctx.stroke(
                    path,
                    with: .color(isMajor ? Color(hex: "7A4F64").opacity(0.9) : Color(hex: "C4899E").opacity(0.55)),
                    lineWidth: lineW
                )
            }
        }
        .frame(width: width, height: height)
    }

    @ViewBuilder
    private func labelsLayer(radius: CGFloat, cx: CGFloat, cy: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        let outerR = radius - 5
        let majorTickLen: CGFloat = 24
        let minI = Int(floor((viewModel.rawAngle - 90) / viewModel.degreesPerKg)) - 60
        let maxI = Int(ceil((viewModel.rawAngle + 90) / viewModel.degreesPerKg)) + 60

        ZStack {
            ForEach(minI...maxI, id: \.self) { i in
                let displayKg = wrappedDisplayKg(for: i)
                let isMajor = displayKg % 5 == 0
                let angleDeg = Double(i) * viewModel.degreesPerKg - viewModel.rawAngle - 90.0

                if isMajor && angleDeg >= -180.0 && angleDeg <= 0.0 {
                    let angleRad = angleDeg * .pi / 180.0
                    let labelR = outerR - majorTickLen - 18
                    Text("\(displayKg)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "5C3650"))
                        .position(x: cx + labelR * CGFloat(cos(angleRad)), y: cy + labelR * CGFloat(sin(angleRad)))
                }
            }
        }
        .frame(width: width, height: height)
    }
}

struct SemicircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    WeightPickerView(selectedWeight: .constant(60))
}
