import Foundation
import CoreML

enum InsurancePremiumPredictorError: LocalizedError {
    case missingOutput
    case modelLoadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingOutput:
            return "Output 'annual_premium_log' tidak ditemukan."
        case .modelLoadFailed(let error):
            return "Gagal memuat model: \(error.localizedDescription)"
        }
    }
}

final class InsurancePremiumPredictor {
    
    private let model: MLModel
    
    init() throws {
        do {
            let config = MLModelConfiguration()
            self.model = try insurance_model(configuration: config).model
        } catch {
            throw InsurancePremiumPredictorError.modelLoadFailed(error)
        }
    }
    
    func predictAnnualPremium(
        age: Double,
        bmi: Double,
        children: Double,
        smokerStatus: SmokerStatus
    ) throws -> Double {
        let input = try buildInputFeatures(age: age, bmi: bmi, children: children, smokerStatus: smokerStatus)
        let output = try model.prediction(from: input)
        
        guard let rawScore = output.featureValue(for: "annual_premium_log")?.doubleValue else {
            throw InsurancePremiumPredictorError.missingOutput
        }
        return Foundation.expm1(rawScore)
    }
    
    private func buildInputFeatures(
        age: Double,
        bmi: Double,
        children: Double,
        smokerStatus: SmokerStatus
    ) throws -> MLDictionaryFeatureProvider {
        let bmiClipped = bmi.clamped(to: 13.67...47.31)
        let smokerEncoded = smokerStatus.encodedValue
        
        let features: [String: Any] = [
            "age":            age,
            "age_squared":    age * age,
            "bmi":            bmiClipped,
            "children":       children,
            "smoker_encoded": smokerEncoded,
            "smoker_bmi":     smokerEncoded * bmiClipped,
        ]
        return try MLDictionaryFeatureProvider(dictionary: features)
    }
}
