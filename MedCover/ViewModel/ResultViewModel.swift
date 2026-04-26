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
    let smokerStatus: SmokerStatus
    let children: Int
}

@MainActor
final class ResultViewModel: ObservableObject {
    @Published private(set) var dataInput: DataInput?

    func buildDataInput(from form: TestInsuranceFormViewModel) {
        guard let smokerStatus = form.smokerStatus else {
            dataInput = nil
            return
        }

        dataInput = DataInput(
            age: form.age,
            gender: form.gender,
            heightCm: form.heightCm,
            weightKg: form.weightKg,
            smokerStatus: smokerStatus,
            children: form.children
        )
    }
}
