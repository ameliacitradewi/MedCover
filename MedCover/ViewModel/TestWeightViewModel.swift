import Foundation
import Combine

@MainActor
final class TestWeightViewModel: ObservableObject {
    @Published var selectedWeight: Int = 60
}
