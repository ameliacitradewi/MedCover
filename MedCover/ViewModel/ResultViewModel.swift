//
//  ResultViewModel.swift
//  MedCover
//
//  Created by Amelia Citra on 26/04/26.
//

import Foundation
import Combine

struct DataInput {
    let age: Int
    let gender: Gender
    let heightCm: Int
    let weightKg: Int
    let bmi: Double
    let smokerStatus: SmokerStatus
    let children: Int
}

@MainActor
final class ResultViewModel: ObservableObject {
    @Published private(set) var dataInput: DataInput?
    @Published private(set) var annualPremium: Double?
    @Published private(set) var errorMessage: String?

    private let predictor: InsurancePremiumPredictor?

    init(predictor: InsurancePremiumPredictor? = try? InsurancePremiumPredictor()) {
        self.predictor = predictor
    }

    func buildDataInput(from form: TestInsuranceFormViewModel) {
        guard let smokerStatus = form.smokerStatus else {
            dataInput = nil
            annualPremium = nil
            errorMessage = "Data belum lengkap: status smoker belum dipilih."
            return
        }

        dataInput = DataInput(
            age: form.age,
            gender: form.gender,
            heightCm: form.heightCm,
            weightKg: form.weightKg,
            bmi: calculateBMI(heightCm: form.heightCm, weightKg: form.weightKg),
            smokerStatus: smokerStatus,
            children: form.children
        )
    }

    func predictAnnualPremium() {
        guard let dataInput else {
            annualPremium = nil
            if errorMessage == nil {
                errorMessage = "Data input belum tersedia."
            }
            return
        }

        guard let predictor else {
            annualPremium = nil
            errorMessage = "Model CoreML belum bisa dimuat."
            return
        }

        do {
            annualPremium = try predictor.predictAnnualPremium(
                age: Double(dataInput.age),
                bmi: dataInput.bmi,
                children: Double(dataInput.children),
                smokerStatus: dataInput.smokerStatus
            )
            errorMessage = nil
        } catch {
            annualPremium = nil
            errorMessage = error.localizedDescription
        }
    }

    func prepareAndPredict(from form: TestInsuranceFormViewModel) {
        buildDataInput(from: form)
        predictAnnualPremium()
    }

    func clearDataInput() {
        dataInput = nil
        annualPremium = nil
        errorMessage = nil
    }

    func calculateBMI(heightCm: Int, weightKg: Int) -> Double {
        let heightM = Double(heightCm) / 100
        guard heightM > 0 else { return 0 }
        return Double(weightKg) / (heightM * heightM)
    }
}
