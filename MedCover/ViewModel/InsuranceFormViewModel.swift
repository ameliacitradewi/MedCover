import Foundation
import Combine

@MainActor
final class InsuranceFormViewModel: ObservableObject {
    private let predictor: InsurancePremiumPredictor

    @Published var ageText: String = ""
    @Published var heightCm: Int = 160
    @Published var weight: Int = 60
    @Published var smokerStatus: SmokerStatus = .no
    @Published var childrenCount: Int = 0

    @Published var predictionText: String = "-"
    @Published var errorMessage: String?

    init(predictor: InsurancePremiumPredictor = InsurancePremiumPredictor()) {
        self.predictor = predictor
    }

    var bmiValue: Double {
        let heightInMeter = Double(heightCm) / 100.0
        guard heightInMeter > 0 else { return 0 }
        return Double(weight) / (heightInMeter * heightInMeter)
    }

    func runPrediction() {
        errorMessage = nil
        predictionText = "Calculating..."

        guard let ageValue = Double(ageText), ageValue > 0 else {
            predictionText = "-"
            errorMessage = "Umur tidak valid."
            return
        }

        guard bmiValue > 0 else {
            predictionText = "-"
            errorMessage = "Tinggi badan tidak valid."
            return
        }

        do {
            let annualPremium = try predictor.predictAnnualPremium(
                age: ageValue,
                bmi: bmiValue,
                children: Double(childrenCount),
                smokerStatus: smokerStatus
            )
            predictionText = String(format: "USD %.2f", annualPremium)
        } catch {
            predictionText = "-"
            errorMessage = "Gagal menjalankan model: \(error.localizedDescription)"
        }
    }
}
