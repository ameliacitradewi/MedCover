import SwiftUI
import CoreML

struct ResultView: View {
    let ageText: String
    let heightCm: Int
    let weight: Int
    let smokerStatus: SmokerStatus
    let childrenCount: Int
    
    @State private var predictionText: String = "-"
    @State private var errorMessage: String?

    private var bmiValue: Double {
        let heightInMeter = Double(heightCm) / 100.0
        guard heightInMeter > 0 else { return 0 }
        return Double(weight) / (heightInMeter * heightInMeter)
    }

    var body: some View {
        VStack(spacing: 18) {
            Text("Result")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 10) {
                Text("Age: \(ageText)")
                Text("Height: \(heightCm) cm")
                Text("Weight: \(weight) kg")
                Text("BMI: \(String(format: "%.2f", bmiValue))")
                Text("Smoker: \(smokerStatus.title) (\(smokerStatus.rawValue))")
                Text("Children: \(childrenCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.gray.opacity(0.15))
            )
            
            VStack(spacing: 8) {
                Text("Estimated Annual Premium")
                    .font(.headline)
                Text(predictionText)
                    .font(.title2.bold())
                    .foregroundStyle(.green)
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Summary")
        .task {
            runPrediction()
        }
    }
    
    private func runPrediction() {
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
            let config = MLModelConfiguration()
            let model = try insurance_model(configuration: config).model
            let input = try buildInputFeatures(
                age: ageValue,
                bmi: bmiValue,
                children: Double(childrenCount),
                smokerStatus: smokerStatus
            )
            let output = try model.prediction(from: input)
            
            guard let rawScore = output.featureValue(for: "annual_premium_log")?.doubleValue else {
                predictionText = "-"
                errorMessage = "Output `annual_premium_log` tidak ditemukan."
                return
            }
            
            let annualPremium = Foundation.expm1(rawScore)
            predictionText = String(format: "USD %.2f", annualPremium)
        } catch {
            predictionText = "-"
            errorMessage = "Gagal menjalankan model: \(error.localizedDescription)"
        }
    }
    
    private func buildInputFeatures(
        age: Double,
        bmi: Double,
        children: Double,
        smokerStatus: SmokerStatus
    ) throws -> MLDictionaryFeatureProvider {
        let bmiClipped = min(max(bmi, 13.67), 47.31)
        let smokerEncoded = Double(smokerStatus.rawValue)
        let ageSquared = age * age
        let smokerBmi = smokerEncoded * bmiClipped
        
        let features: [String: Any] = [
            "age": age,
            "age_squared": ageSquared,
            "bmi": bmiClipped,
            "children": children,
            "smoker_encoded": smokerEncoded,
            "smoker_bmi": smokerBmi,
        ]
        
        return try MLDictionaryFeatureProvider(dictionary: features)
    }
}

#Preview {
    ResultView(ageText: "28", heightCm: 170, weight: 64, smokerStatus: .no, childrenCount: 2)
}
