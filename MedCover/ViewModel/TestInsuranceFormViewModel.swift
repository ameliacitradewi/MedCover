import Foundation
import Combine

@MainActor
final class TestInsuranceFormViewModel: ObservableObject {
    @Published var age: Int = 0
    @Published var gender: Gender = .female
    @Published var heightCm: Int = 160
    @Published var weightKg: Int = 60
    @Published var smokerStatus: SmokerStatus? = nil
    @Published var children: Int = 0
}
