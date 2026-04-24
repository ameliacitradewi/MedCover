import SwiftUI

// MARK: - Main View
struct WeightPickerView: View {
    @Binding var selectedWeight: Int
    @State private var rawAngle: Double = 0
    @State private var lastRawAngle: Double = 0

    let degreesPerKg: Double = 3.0
    let minKg: Int = 0
    let maxKg: Int = 150

    var currentWeight: Int {
        let kgRaw = rawAngle / degreesPerKg
        return Int(kgRaw.rounded()).clamped(to: minKg...maxKg)
    }

    var body: some View {
        ZStack {
            Color(.clear).ignoresSafeArea()

            VStack(spacing: 0) {
                Text("What is your weight?")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 30)
                
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(currentWeight)")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(hex: "1A202C"))
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: currentWeight)

                    Text("kg")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "C0C8D8"))
                        .padding(.bottom, 10)
                }

                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "4CAF50"))

                ZStack(alignment: .bottom) {
                    InfiniteDialView(
                        rawAngle: $rawAngle,
                        lastRawAngle: $lastRawAngle,
                        degreesPerKg: degreesPerKg,
                        minKg: minKg,
                        maxKg: maxKg
                    )
                    .frame(height: 200)
                }
            }
            .padding()
        }
        .onAppear {
            let initial = selectedWeight.clamped(to: minKg...maxKg)
            rawAngle = Double(initial) * degreesPerKg
            lastRawAngle = rawAngle
        }
        .onChange(of: currentWeight) {_, newValue in
            selectedWeight = newValue
        }
    }
}

// MARK: - Infinite Dial
struct InfiniteDialView: View {
    @Binding var rawAngle: Double
    @Binding var lastRawAngle: Double

    let degreesPerKg: Double
    let minKg: Int
    let maxKg: Int

    // Untuk tampilan skala: setelah 150, lanjut tampil 1..150 lagi
    private func wrappedDisplayKg(for index: Int) -> Int {
        let cycle = maxKg
        guard cycle > 0 else { return 0 }
        var value = index % cycle
        if value <= 0 { value += cycle }
        return value
    }

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height
            let radius: CGFloat = W / 2.05
            let cx = W / 2
            let cy = H  // pivot = flat bottom edge

            ZStack {
                // Pink semicircle — clips everything inside
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

                // Ticks: pure SwiftUI shapes, di-clip oleh SemicircleShape
                // Teks: ZStack overlay terpisah dengan visibility check per sudut
                ticksLayer(radius: radius, cx: cx, cy: cy, W: W, H: H)
                    .clipShape(SemicircleShape())  // clip ticks ke dalam semicircle

                labelsLayer(radius: radius, cx: cx, cy: cy, W: W, H: H)

                // Drag
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { val in
                                let pxPerDeg = CGFloat(radius) * .pi / 180.0
                                let deltaDeg = Double(-val.translation.width / pxPerDeg)
                                withAnimation(.interactiveSpring(response: 0.12, dampingFraction: 0.9)) {
                                    let nextAngle = lastRawAngle + deltaDeg
                                    let minAngle = Double(minKg) * degreesPerKg
                                    let maxAngle = Double(maxKg) * degreesPerKg
                                    rawAngle = nextAngle.clamped(to: minAngle...maxAngle)
                                }
                            }
                            .onEnded { val in
                                let pxPerDeg = CGFloat(radius) * .pi / 180.0
                                let deltaDeg = Double(-val.translation.width / pxPerDeg)
                                let finalAngle = lastRawAngle + deltaDeg
                                let snapped = (finalAngle / degreesPerKg).rounded() * degreesPerKg
                                let minAngle = Double(minKg) * degreesPerKg
                                let maxAngle = Double(maxKg) * degreesPerKg
                                let clampedSnapped = snapped.clamped(to: minAngle...maxAngle)
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                    rawAngle = clampedSnapped
                                }
                                lastRawAngle = clampedSnapped
                            }
                    )
            }
        }
    }

    // MARK: Ticks via Canvas (di-clip ke semicircle)
    @ViewBuilder
    func ticksLayer(radius: CGFloat, cx: CGFloat, cy: CGFloat, W: CGFloat, H: CGFloat) -> some View {
        Canvas { ctx, size in
            ctx.translateBy(x: cx, y: cy)

            let visibleStartAngle: Double = -180.0
            let visibleEndAngle: Double = 0.0
            let minI = Int(floor((rawAngle + 90 + visibleStartAngle) / degreesPerKg)) - 1
            let maxI = Int(ceil((rawAngle + 90 + visibleEndAngle) / degreesPerKg)) + 1

            for i in minI...maxI {
                let displayKg = wrappedDisplayKg(for: i)

                let isMajor = displayKg % 5 == 0

                let angleDeg = Double(i) * degreesPerKg - rawAngle - 90.0
                let angleRad = angleDeg * .pi / 180.0

                let outerR = radius - 5
                let tickLen: CGFloat = isMajor ? 24 : 13
                let lineW: CGFloat   = isMajor ? 2.4 : 1.2

                let x1 = outerR * CGFloat(cos(angleRad))
                let y1 = outerR * CGFloat(sin(angleRad))
                let x2 = (outerR - tickLen) * CGFloat(cos(angleRad))
                let y2 = (outerR - tickLen) * CGFloat(sin(angleRad))

                var path = Path()
                path.move(to: CGPoint(x: x1, y: y1))
                path.addLine(to: CGPoint(x: x2, y: y2))

                ctx.stroke(
                    path,
                    with: .color(isMajor
                        ? Color(hex: "7A4F64").opacity(0.9)
                        : Color(hex: "C4899E").opacity(0.55)),
                    lineWidth: lineW
                )
            }
        }
        .frame(width: W, height: H)
    }

    // MARK: Labels via ZStack — render di seluruh area semicircle atas
    // Arc semicircle atas: sudut -180° (kiri bawah) sampai 0° (kanan bawah)
    @ViewBuilder
    func labelsLayer(radius: CGFloat, cx: CGFloat, cy: CGFloat, W: CGFloat, H: CGFloat) -> some View {
        let outerR = radius - 5
        let majorTickLen: CGFloat = 24

        // Hitung range i yang mungkin terlihat di arc setengah lingkaran atas
        let visibleStartAngle: Double = -180.0
        let visibleEndAngle: Double = 0.0
        let minI = Int(floor((rawAngle + 90 + visibleStartAngle) / degreesPerKg)) - 1
        let maxI = Int(ceil((rawAngle + 90 + visibleEndAngle) / degreesPerKg)) + 1

        ZStack {
            ForEach(minI...maxI, id: \.self) { i in
                let displayKg = wrappedDisplayKg(for: i)
                let isMajor = displayKg % 5 == 0
                let angleDeg = Double(i) * degreesPerKg - rawAngle - 90.0

                // Tampilkan seluruh label yang berada di arc semicircle atas
                let visible = angleDeg >= -180.0 && angleDeg <= 0.0

                if visible && isMajor {
                    let angleRad = angleDeg * .pi / 180.0
                    let labelR = outerR - majorTickLen - 18
                    let lx = cx + labelR * CGFloat(cos(angleRad))
                    let ly = cy + labelR * CGFloat(sin(angleRad))

                    Text("\(displayKg)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "5C3650"))
                        .position(x: lx, y: ly)
                }
            }
        }
        .frame(width: W, height: H)
        // TIDAK di-clip — teks boleh sedikit melampaui semicircle agar tidak terpotong
    }
}

// MARK: - Semicircle Shape
struct SemicircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = rect.width / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

// MARK: - Next Page
struct NextPageView: View {
    let weight: Int

    var body: some View {
        ZStack {
            Color(hex: "F2F5FF").ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "4389F5"))

                Text("Berat Badan Tersimpan!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1A202C"))

                Text("\(weight) kg")
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "4389F5"))

                Text("Lanjutkan ke langkah berikutnya")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "9AA5B4"))
            }
        }
        .navigationTitle("Konfirmasi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    WeightPickerPreview()
}

private struct WeightPickerPreview: View {
    @State private var selectedWeight: Int = 60

    var body: some View {
        WeightPickerView(selectedWeight: $selectedWeight)
    }
}
