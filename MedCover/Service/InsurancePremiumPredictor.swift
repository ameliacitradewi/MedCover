import Foundation
import CoreML

enum InsurancePremiumPredictorError: LocalizedError {
    case missingOutput

    var errorDescription: String? {
        switch self {
        case .missingOutput:
            return "Output `annual_premium_log` tidak ditemukan."
        }
    }
}

struct InsurancePremiumPredictor {
    func predictAnnualPremium(
        age: Double,
        bmi: Double,
        children: Double,
        smokerStatus: SmokerStatus
    ) throws -> Double {
        let config = MLModelConfiguration()
        let model = try insurance_model(configuration: config).model
        let input = try buildInputFeatures(
            age: age,
            bmi: bmi,
            children: children,
            smokerStatus: smokerStatus
        )
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
        let bmiClipped = min(max(bmi, 13.67), 47.31)
        let smokerEncoded = smokerStatus.encodedValue
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
