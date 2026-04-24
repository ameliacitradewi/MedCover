import Foundation
import Combine

@MainActor
final class InsuranceFormViewModel: ObservableObject {
    private var predictor: InsurancePremiumPredictor?
    private var predictionTask: Task<Void, Never>?

    @Published var ageText: String = ""
    @Published var heightCm: Int = 160
    @Published var weight: Int = 60
    @Published var smokerStatus: SmokerStatus = .no
    @Published var childrenCount: Int = 0

    @Published var predictionText: String = "-"
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init() {
        do {
            self.predictor = try InsurancePremiumPredictor()
        } catch {
            self.predictor = nil
            self.errorMessage = error.localizedDescription
        }
    }

    var bmiValue: Double {
        let heightInMeter = Double(heightCm) / 100.0
        guard heightInMeter > 0 else { return 0 }
        return Double(weight) / (heightInMeter * heightInMeter)
    }

    func runPrediction() {          // ← Hapus 'async'
        predictionTask?.cancel()    // Cancel task lama jika ada
        
        errorMessage = nil
        isLoading = true
        predictionText = "Calculating..."

        guard let predictor else {
            isLoading = false
            predictionText = "-"
            errorMessage = "Model gagal dimuat."
            return
        }

        guard let ageValue = Double(ageText), ageValue >= 18, ageValue <= 65 else {
            isLoading = false
            predictionText = "-"
            errorMessage = "Umur harus antara 18-65 tahun."
            return
        }

        guard bmiValue > 0 else {
            isLoading = false
            predictionText = "-"
            errorMessage = "Tinggi badan tidak valid."
            return
        }

        let bmi = bmiValue
        let children = Double(childrenCount)
        let smoker = smokerStatus

        predictionTask = Task {
            do {
                let annualPremium = try await predictor.predictAnnualPremium(
                    age: ageValue,
                    bmi: bmi,
                    children: children,
                    smokerStatus: smoker
                )
                isLoading = false
                predictionText = String(format: "USD %.2f", annualPremium)
            } catch is CancellationError {
                isLoading = false   // User navigasi back — silent cancel
            } catch {
                isLoading = false
                predictionText = "-"
                errorMessage = "Gagal menjalankan model: \(error.localizedDescription)"
            }
        }
    }
    
    func cancelPrediction() {
        predictionTask?.cancel()
        predictionTask = nil
    }
    
}
