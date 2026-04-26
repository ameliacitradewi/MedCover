import SwiftUI
import Combine

@MainActor
final class WeightPickerViewModel: ObservableObject {
    @Published var rawAngle: Double = 0
    @Published var lastRawAngle: Double = 0

    let degreesPerKg: Double
    let minKg: Int
    let maxKg: Int

    init(degreesPerKg: Double = 3.0, minKg: Int = 0, maxKg: Int = 150) {
        self.degreesPerKg = degreesPerKg
        self.minKg = minKg
        self.maxKg = maxKg
    }

    var currentWeight: Int {
        let kgRaw = rawAngle / degreesPerKg
        return Int(kgRaw.rounded()).clamped(to: minKg...maxKg)
    }

    func syncFromSelectedWeight(_ weight: Int) {
        let initial = weight.clamped(to: minKg...maxKg)
        rawAngle = Double(initial) * degreesPerKg
        lastRawAngle = rawAngle
    }

    func handleDragChanged(translationWidth: CGFloat, radius: CGFloat) {
        let pxPerDeg = radius * .pi / 180.0
        guard pxPerDeg != 0 else { return }

        let deltaDeg = Double(-translationWidth / pxPerDeg)
        let nextAngle = lastRawAngle + deltaDeg
        let minAngle = Double(minKg) * degreesPerKg
        let maxAngle = Double(maxKg) * degreesPerKg
        rawAngle = nextAngle.clamped(to: minAngle...maxAngle)
    }

    func handleDragEnded(translationWidth: CGFloat, radius: CGFloat) {
        let pxPerDeg = radius * .pi / 180.0
        guard pxPerDeg != 0 else { return }

        let deltaDeg = Double(-translationWidth / pxPerDeg)
        let finalAngle = lastRawAngle + deltaDeg
        let snapped = (finalAngle / degreesPerKg).rounded() * degreesPerKg
        let minAngle = Double(minKg) * degreesPerKg
        let maxAngle = Double(maxKg) * degreesPerKg
        let clampedSnapped = snapped.clamped(to: minAngle...maxAngle)
        rawAngle = clampedSnapped
        lastRawAngle = clampedSnapped
    }
}
